module Importable
  extend ActiveSupport::Concern

  included do
    has_many   :csv_files, dependent: :destroy, inverse_of: :import
  end

  def run
    if finished?
      create_update( "This import has already been ran", "WARNING" )
    else
      create_update( "Running importer", "NOTE" )
      csv_files.each do |csv_file|
        import_file( csv_file.file.read )
      end
      #create_update "takeout", "ERROR"
      notify_complete
    end
  end

  def import_file( csv_file_string )
    CSV.parse( csv_file_string ) do |row|
      @row = row
      if headers.empty?
        set_headers( row )
      else
        import_row( row )
      end
    end
  end

  def import_row( row )
    begin
      client = Client.find_or_initialize_by( name: get_value(:customer) )
      save_and_notify_created( client, :name ) unless client.persisted?

      job = Job.find_or_initialize_by( name: get_value(:job_name), client: client )
      save_and_notify_created( job, :name ) unless job.persisted?

      rig = Rig.find_or_initialize_by(    name: get_value(:rig_name) )
      save_and_notify_created( rig, :name ) unless rig.persisted?

      formation = Formation.find_or_initialize_by( name: get_value( :formation_name ) )
      save_and_notify_created( formation, :name ) unless formation.persisted? || formation.name.nil?

      well = Well.find_or_initialize_by(   name: get_value(:well_name) )
      save_and_notify_created( well, :name ) unless well.persisted?

      formation.wells << well if well.persisted? && formation.persisted?

      tt_name = if !get_value(:name).blank?
                  get_value(:name)
                elsif !get_value(:tool_description).blank?
                  get_value(:tool_description)
                else
                  "Unknown"
                end
      tool_type = ToolType.find_or_initialize_by( name: tt_name, description: get_value( :tool_description ))
      save_and_notify_created( tool_type, :name ) unless tool_type.persisted?

      tool = Tool.fuzzy_find_or_initialize_by( get_value( :tool_serial_number ), tool_type )
      save_and_notify_created( tool, :serial_number ) unless tool.persisted?

      runs = Run.where( job: job, well: well, rig: rig)
      run_number = get_value( :run_number ).to_i
      run = runs.select{ |r| r.number == run_number }.first unless runs.blank?
      run ||= Run.new( job: job, well: well, rig: rig, number: run_number )

      run_record = run.persisted? ? RunRecord.find_or_initialize_by( tool: tool, run: run ) : RunRecord.new( tool: tool )

      unless run_record.persisted?

        art_string = get_value( :art )
        art = Date.strptime( art_string, '%m/%d/%Y' ) if art_string

        brt_string = get_value( :brt )
        brt = Date.strptime( brt_string, '%m/%d/%Y' ) if brt_string

        run_record.assign_attributes agitator:              get_value( :agitator ),
                                     brt:                   brt,
                                     art:                   art,
                                     motor_bend:            get_value( :motor_bend ),
                                     rpm:                   get_value( :rpm ),
                                     chlorides:             get_value( :chlorides ),
                                     bit_type:              get_value( :bit_type ),
                                     circulating_hrs:       get_value( :circulating_hrs ),
                                     rotating_hours:        get_value( :rotating_hours ),
                                     sliding_hours:         get_value( :sliding_hours ),
                                     total_drilling_hours:  get_value( :total_drilling_hours ),
                                     mud_weight:            get_value( :mud_weight ),
                                     max_temperature:       get_value( :max_temperature ),
                                     gpm:                   get_value( :gpm ),
                                     sand:                  get_value( :sand ),
                                     bha:                   get_value( :bha ),
                                     agitator_distance:     get_value( :agitator_distance),
                                     mud_type:              get_value( :mud_type )

        Run.transaction do
          run.save!
          run_record.run = run
          run_record.import = self
          run_record.save!
        end

        save_and_notify_created( run, :number )
      end
    rescue ActiveRecord::RecordInvalid => e
      create_update e.record.class.model_name.human + " ~> " + e.message, "ERROR"
    rescue ActiveRecord => e
      create_update e.message, "FAILURE"
    end

  end

  def set_headers( row )
    row.each_with_index do |value,index|
      constant = map_to_constant( value )
      headers.merge! constant => index if constant
    end
  end

  def headers
    @headers ||= {}
  end

  def map_to_constant( value )
    klass.constant_map[value]
  end

  def get_value( sym )
    begin
    value = @row[headers[sym]]
    rescue
      description = "You appear to be missing a column."
      import_updates.create! description: description, update_type: "ERROR"
      Pusher["import-#{id}"].trigger("update", description)
      raise 'Failed to get a valid value. Could be missing a header'
    end

    !value.blank? && value.include?( "?" ) ? nil : value
  end

  def klass
    self.class
  end

  def create_update( description, type=nil )
    type ||= "NOTE"
    import_updates.create! description: description, update_type: type
    Pusher["import-#{id}"].trigger("update", description) unless Rails.env.test?
  end

  def save_and_notify_created( object, sym )
    object.save!
    create_update "Couldn't find #{object.class.model_name.human}: #{object.send( sym )} so a new one was created."
  end

  def notify_complete
    unless update_errors.count > 0
      create_update( "Successfully finished the " + Import.model_name.human + ". " + counts_string, "FINISHED" )
    else
      create_update "The import has completed but has " + update_errors.count.to_s + " errors. " + counts_string, "INCOMPLETE"
    end
  end

  def counts_string
    " Counts: " +
    Job.model_name.human.pluralize + ": " + Job.where( "created_at > ?", last_run_at.utc.to_s( :db ) ).count.to_s + " " +
    Tool.model_name.human.pluralize + ": " + Tool.where( "created_at > ?", last_run_at.utc.to_s( :db ) ).count.to_s + " " +
    ToolType.model_name.human.pluralize + ": " + ToolType.where( "created_at > ?", last_run_at.utc.to_s( :db ) ).count.to_s + " " +
    Formation.model_name.human.pluralize + ": " + Formation.where( "created_at > ?", last_run_at.utc.to_s( :db ) ).count.to_s + " " +
    RunRecord.model_name.human.pluralize + ": " + RunRecord.where( "created_at > ?", last_run_at.utc.to_s( :db ) ).count.to_s + " " +
    Run.model_name.human.pluralize + ": " + Run.where( "created_at > ?", last_run_at.utc.to_s( :db ) ).count.to_s + " " +
    Well.model_name.human.pluralize + ": " + Well.where( "created_at > ?", last_run_at.utc.to_s( :db ) ).count.to_s
  end
end
