class Region < ActiveRecord::Base
  has_many :truck_requests

  scope :active, lambda { where(active: true) }

  validates :name, presence: true, uniqueness: true
end
