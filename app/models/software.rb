class Software < ActiveRecord::Base
  belongs_to :software_type, touch: true

  validates_presence_of :software_type
  validates_presence_of :version
  attr_accessor :installer_name
  include Authority::Abilities

  mount_uploader :binary, SoftwareBinaryUploader

  # regex: http://rubular.com/r/3FpqVh1nSP
  validates_format_of :version,          with: /\A(\d+)\.(\d+)\.(\d+)\z/

  delegate :name, to: :software_type

  before_validation do
    self["binary"] = installer_name if installer_name
  end

  def self.search keywords
    if keywords.present?
      software_type = SoftwareType.where("name @@ ?", "%#{keywords}%").take
      if software_type then software_type_id = software_type.id end
      where(software_type_id: software_type_id)
    end
  end

  def <=> other
    OrderedVersion.new(version) <=> OrderedVersion.new(other.version)
  end
end
