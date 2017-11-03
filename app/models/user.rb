class User < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true, allow_nil: false
  validates :email, presence: true, allow_nil: false, uniqueness: {scope: :email}
  include Authority::UserAbilities
  include Authority::Abilities
  after_initialize :init

  before_validation on: :create do
    self.email.try(:strip!)
  end

  has_many :imports
  has_many :exports, as: :exportable
  has_many :alerts, class_name: 'Alert', foreign_key: 'assignee_id'
  has_many :notifications, class_name: 'Notification', foreign_key: 'cleared_by_id'
  has_many :requested_alerts, class_name: 'Alert', foreign_key: 'requester_id'
  has_many :firmware_updates, class_name: 'FirmwareUpdate', foreign_key: 'last_edit_by_id'
  has_many :report_requests, class_name: 'ReportRequest', foreign_key: 'requested_by_id'
  has_many :surveys, class_name: 'Surveys', foreign_key: 'accepted_by_id'
  has_many :surveys, class_name: 'Surveys', foreign_key: 'declined_by_id'
  has_many :threshold_settings
  has_many :templates

  scope :alpha, -> { order("name ASC") }

  def settings
    read_attribute(:settings) || User.default_settings
  end

  def create_export!( objects_json )
    path = write_file( create_csv_string( objects_json ) )
    exports.build( file: File.open( path ) )
    self.save!
    File.delete( path ) if File.exist?( path )
  end

  def create_csv_string( objects_json )
    first_line = true
    csv_string = CSV.generate do |csv|
      objects_json.each do |hash|
        json = format_times( hash )
        if first_line
          csv << json.keys.collect do |key|
            Export.human_attribute_name( key )
          end
          first_line = false
        end
        csv << json.values
      end
    end
  end

  def format_times( tool_json )
    %w( created_at updated_at time ).each do |attr|
      tool_json.merge!(  attr => Time.parse(tool_json[attr]).strftime( "%Y/%m/%d %H:%M:%S %Z" ) ) if tool_json[attr] && !tool_json[attr].blank?
    end
    tool_json
  end

  def write_file( csv_string )
    directory = "tmp/csv_exports/"
    filename = "#{DateTime.now.strftime( "%Y%m%d%H%M" )}_#{id}.csv"
    path = directory + filename
    Dir.mkdir directory unless Dir.exists? directory
    File.write( path, csv_string )
    path
  end

  def has_role? role
    Array(roles).map(&:parameterize).map(&:to_sym).include? role
  end

  def roles
    self["roles"] || []
  end

  def roles=( value )
    write_attribute( :roles, value.delete_if(&:blank?) )
  end

  def init
    self.roles ||= []
  end

  # taken from http://asciicasts.com/episodes/274-remember-me-reset-password
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def self.default_settings
    {
      headers: {
        tools: {
          headers: [
            {
              ordered: true,
              key: 'tool_type.name',
              label: 'Type'
            },
            {
              ordered: true,
              key: 'cache.board_serial_number',
              label: 'Board Serial #'
            },
            {
              ordered: true,
              key: 'cache.primary_asset_number',
              label: 'Asset #'
            },
            {
              ordered: true,
              key: 'cache.job_number',
              label: 'Job'
            },
            {
              ordered: true,
              key: 'cache.run_number',
              label: 'Run'
            },
            {
              ordered: false,
              key: 'cache.memory_usage_level',
              label: 'Mem Lvl'
            },
            {
              ordered: true,
              key: 'cache.hardware_version',
              label: 'HW'
            },
            {
              ordered: true,
              key: 'cache.board_firmware_version',
              label: 'FW'
            },
            {
              ordered: true,
              key: 'cache.max_temperature',
              label: 'Max Temp'
            },
            {
              ordered: true,
              key: 'total_service_time',
              label: 'Total Service Time'
            },
            {
              ordered: true,
              key: 'cache.event_assets',
              label: 'Event Assets'
            },
            {
              ordered: true,
              key: 'cache.created_at',
              label: 'Last Connected'
            }
          ]
        },
        memories: {
          headers: [
            {
              ordered: true,
              key: 'event_type',
              label: 'Event Type'
            },
            {
              ordered: true,
              key: 'hardware_version',
              label: 'HW'
            },
            {
              ordered: true,
              key: 'board_firmware_version',
              label: 'FW'
            },
            {
              ordered: true,
              key: 'job_number',
              label: 'Job'
            },
            {
              ordered: true,
              key: 'run_number',
              label: 'Run'
            },
            {
              ordered: true,
              key: 'board_serial_number',
              label: 'Board Serial #'
            },
            {
              ordered: true,
              key: 'primary_asset_number',
              label: 'Asset'
            },
            {
              ordered: true,
              key: 'reporter_context',
              label: 'Reporter Context'
            },
            {
              ordered: true,
              key: 'user_email',
              label: 'Email'
            },
            {
              ordered: true,
              key: 'region',
              label: 'Region'
            },
            {
              ordered: false,
              key: 'memory_usage_level',
              label: 'Mem Usage Level'
            },
            {
              ordered: true,
              key: 'event_assets',
              label: 'Event Assets'
            },
            {
              ordered: true,
              key: 'max_temperature',
              label: 'Max Temp'
            },
            {
              ordered: true,
              key: 'time',
              label: 'Time'
            }
          ]
        },
        receivers: {
          headers: [
            {
              ordered: true,
              key: 'job',
              label: 'Job'
            },
            {
              ordered: false,
              key: 'run',
              label: 'Run'
            },
            {
              ordered: true,
              key: 'client',
              label: 'Client'
            },
            {
              ordered: true,
              key: 'rig',
              label: 'Rig'
            },
            {
              ordered: true,
              key: 'well',
              label: 'Well'
            },
            {
              ordered: false,
              key: 'decode_percentage',
              label: 'Decode %'
            },
            {
              ordered: false,
              key: 'pump_on_time',
              label: 'Pump On Time'
            },
            {
              ordered: false,
              key: 'inc',
              label: 'INC'
            },
            {
              ordered: false,
              key: 'average_quality',
              label: 'Average Quality'
            }
          ]
        },
        installs: {
          headers: [
            {
              ordered: true,
              key: 'version',
              label: 'Version'
            },
            {
              ordered: true,
              key: 'team_viewer_id',
              label: 'Team Viewer ID'
            },
            {
              ordered: true,
              key: 'user_email',
              label: "User's Email"
            },
            {
              ordered: true,
              key: 'region',
              label: 'Region'
            },
            {
              ordered: true,
              key: 'reporter_context',
              label: 'Reporter Context'
            },
            {
              ordered: true,
              key: 'job_number',
              label: 'Job'
            },
            {
              ordered: true,
              key: 'run_number',
              label: 'Run'
            },
            {
              ordered: true,
              key: 'updated_at',
              label: 'Updated At'
            }
          ]
        }
      }
    }
  end

  def follow job_number
    unless self.follows? job_number.upcase
      follows_will_change!
      follows.push job_number.upcase
      save
    end
  end

  def unfollow job_number
    follows_will_change!
    follows.delete job_number.upcase
    save
  end

  def follows? job_number
    self.follows.include? job_number.upcase
  end

  def self.search keyword
    where("name @@ :k or email @@ :k", k: keyword)
  end
end
