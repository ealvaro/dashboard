class FirmwareUpdate < ActiveRecord::Base
  include Authority::Abilities

  mount_uploader :binary, BinaryUploader

  # regex: http://rubular.com/r/3FpqVh1nSP
  validates_format_of :version,          with: /\A(\d+)\.(\d+)\.(\d+)\z/
  validates_format_of :hardware_version, with: /\A(\d+)\.(\d+)\.(\d+)\z/

  validates_presence_of :tool_type, :version, :binary, :hardware_version

  belongs_to :last_edit_by, class_name: "User"

  validates_presence_of :last_edit_by

  def self.search tools
    names = []
    if tools then tools.each { |t| names << t.tool_type.name } end
    where(tool_type: names.flatten.uniq)
  end

  def contexts
    self["contexts"] || []
  end

  def contexts=( value )
    write_attribute( :contexts, value.delete_if(&:blank?) )
  end

  def regions
    self["regions"] || []
  end

  def regions=( value )
    write_attribute( :regions, value.delete_if(&:blank?) )
  end

  def for_serial_numbers
    (self["for_serial_numbers"] || "").split(",").map(&:strip)
  end

end
