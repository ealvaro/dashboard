class ReportRequestAsset < ActiveRecord::Base
  belongs_to :report_request, touch: true
  mount_uploader :file, ReportUploader
  validates_presence_of :file, allow_nil: false
end
