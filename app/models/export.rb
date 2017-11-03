class Export < ActiveRecord::Base
  belongs_to :exportable, polymorphic: true
  mount_uploader :file, ExportUploader

  validates_presence_of :file, allow_nil: false
end
