class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  mount_uploader :file, ImageUploader

  validates :name, presence: true, allow_blank: false
  validates :file, presence: true, allow_blank: false
end