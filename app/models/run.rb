class Run < ActiveRecord::Base
  include Authority::Abilities
  include BillableRun
  include HasRemoteOpsUpdates
  include PgSearch

  belongs_to :job
  belongs_to :well
  belongs_to :rig
  belongs_to :invoice
  has_many :surveys
  has_many :subscriptions
  has_many :gammas

  #TODO I can't make this join uniq
  has_many :tools, through: :run_records
  has_many :run_records, dependent: :destroy
  has_many :events, dependent: :nullify
  #belongs_to :mud_type
  has_many :damages, dependent: :destroy
  has_many :report_requests
  has_many :histograms

  # multisearchable :against => :number

  pg_search_scope :pg_search,
                :against => [:number],
                :using => {
                  :tsearch => {
                    :prefix => true
                  }
                }

  validates_presence_of :job

  validate :occurred do
    errors.add( :occurred, "cannot be in the future" ) if occurred && DateTime.now < occurred
  end

  def self.search jobs
    ids = []
    if jobs then jobs.each { |j| ids << j.run_ids } end
    where id: ids.flatten.uniq
  end

  def self.fuzzy_find(job, run_number)
    number = run_number
    unless number.blank? || job.blank?
      Run.find_by(job_id: job.id, number: number)
    else
      nil
    end
  end

  def update_attributes_from_invoice( hash )
    Run.transaction do
      hash["damages_as_billed"] = hash["damages_as_billed"].delete_if{ |type, damage| damage.is_a?(Hash) && (damage.blank? || (damage["amount"] == 0 && !damage["altered"]))}
      damages.destroy_all
      hash["damages_as_billed"].each do |k,v|
        if v.is_a? Hash
          damage = Damage.new( run: self, damage_group: k )
          damage.original_amount_in_cents = v["original_amount_in_cents"]
          damage.amount_in_cents_as_billed = v["amount"]
          damage.description = v["description"]
          damage.save!
        end
      end
      self.update_attributes!( hash.select!{ |attr| valid_invoice_attrs.include?( attr.to_sym ) } )
    end
  end

  private

  def valid_invoice_attrs
    [:max_temperature_as_billed, :item_start_hrs_as_billed, :circulating_hrs_as_billed, :rotating_hours_as_billed,
    :sliding_hours_as_billed, :total_drilling_hours_as_billed, :mud_weight_as_billed, :gpm_as_billed,
    :bit_type_as_billed, :motor_bend_as_billed, :rpm_as_billed, :chlorides_as_billed, :sand_as_billed, :brt_as_billed,
    :art_as_billed, :bha_as_billed, :agitator_distance_as_billed, :mud_type_as_billed, :agitator_as_billed, :dd_hours_as_billed,
    :max_shock_as_billed, :max_vibe_as_billed, :shock_warnings_as_billed, :damages_as_billed]
  end
end
