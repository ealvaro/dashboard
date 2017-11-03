class Event < ActiveRecord::Base
  include RunLinkable

  belongs_to :tool, touch: true, counter_cache: true
  has_one :tool_type, through: :tool
  belongs_to :run, touch: true
  belongs_to :report_type
  belongs_to :job
  belongs_to :client
  belongs_to :rig
  belongs_to :well

  has_many :event_assets, dependent: :destroy, before_add: :add_uid_to_asset

  validate :event_type, presence: true, allow_nil: false
  validate :tool, presence: true, allow_nil: false
  validate :time, presence: true, allow_nil: false
  validate :reporter_type, presence: true, allow_nil: false
  validates :run_number, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than: 256 }
  validates_presence_of %i(tool event_type time reporter_type)

  after_save :link_to_run

  serialize :tags, JSON

  scope :statuses, -> { where( "event_type in ( 'Status - In Service', 'Status - In Development', 'Status - In Repair', 'Status - Retired - Preemptive Replacement', 'Status - Retired - Down-hole Failure', 'Status - Retired - Shop Damage')" ) }

  scope :not_config, -> { where.not("event_type ilike ?", "%config%") }
  scope :memories, -> { where( event_type: "Memory - Download" ) }

  def self.search keywords
    if keywords.present?
      where("job_number ilike :k OR
        primary_asset_number ilike :k OR
        board_serial_number ilike :k",
        k: "%#{keywords}%")
    end
  end

  def self.memory_search keywords
    if keywords.present?
      where("job_number ilike :k OR
        primary_asset_number ilike :k OR
        board_serial_number ilike :k",
        k: "%#{keywords}%")
    else
      all
    end
  end

  def notify!
    if !tags.blank? && tags.select{ |k,v| k == "crossover" }.length > 0
      EventNotifier.crossover_email( self )
    elsif event_type == "Warning - Surface Crossover"
      EventNotifier.crossover_detected_email( self )
    end
  end

  def asset_file_name=(name)
    self["asset"] = name
  end

  def configs
    self["configs"] || {}
  end

  def add_uid_to_asset(asset)
    asset.uid = tool.uid
  end
end
