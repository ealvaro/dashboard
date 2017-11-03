class CsvFile < ActiveRecord::Base
  belongs_to :import, touch: true
  mount_uploader :file, CsvUploader

  validates_presence_of :file, allow_nil: false
end
