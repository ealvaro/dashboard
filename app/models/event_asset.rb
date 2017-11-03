class EventAsset < ActiveRecord::Base
  belongs_to :event, touch: true
  mount_uploader :file, AssetUploader
  validates_presence_of :file, allow_nil: false
end
