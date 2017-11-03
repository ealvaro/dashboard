require 'csv'

class Import < ActiveRecord::Base
  include Importable

  belongs_to :user
  has_many   :run_records
  has_many   :import_updates

  validates :user, presence: true, allow_nil: false

  accepts_nested_attributes_for :csv_files

  def update_errors
    last_run_at.blank? ? [] : import_updates.where( "created_at > ? AND update_type = ?", last_run_at.utc.to_s( :db), "ERROR" )
  end

  def status
    finished? ? "Finished" : "Incomplete"
  end

  def finished?
    import_updates.where( update_type: "FINISHED" ).count > 0
  end

  def incomplete?
    import_updates.last.update_type == "INCOMPLETE"
  end

  def incomplete_updates
    import_updates.where( update_type: "INCOMPLETE" )
  end

  def last_run_at
    return nil if import_updates.first.nil?
    return import_updates.first.created_at if incomplete_updates.count == 0
    created_at = if incomplete?
                   incomplete_updates.all[-2].created_at
                 else
                   incomplete_updates.last.created_at
                 end
    created_at + 1.second
  end

  def self.constant_map
    { "Job Number"           => :job_name,
      "Customer"             => :customer,
      "Rig Name"             => :rig_name,
      "Well Name"            => :well_name,
      "Target Formation"     => :formation_name,
      "Product Line"         => :tool_description,
      "Resource Group"       => :name,
      "Serial Number"        => :tool_serial_number,
      "Run"                  => :run_number,
      "BHA"                  => :bha,
      "Incident"             => :incident,
      "Max Temperature"      => :max_temperature,
      "Circulating Hrs"      => :circulating_hrs,
      "Rotating Hours"       => :rotating_hours,
      "Sliding Hours"        => :sliding_hours,
      "Total Drilling Hours" => :total_drilling_hours,
      "Mud Weight"           => :mud_weight,
      "GPM"                  => :gpm,
      "Bit Type"             => :bit_type,
      "Motor Bend"           => :motor_bend,
      "RPM"                  => :rpm,
      "Chlorides"            => :chlorides,
      "Sand"                 => :sand,
      "Mud Type"             => :mud_type,
      "Agitator"             => :agitator,
      "Agitator Distance"    => :agitator_distance,
      "BRT"                  => :brt,
      "ART"                  => :art}

  end
end
