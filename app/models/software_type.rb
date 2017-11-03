class SoftwareType < ActiveRecord::Base
  has_many :software, dependent: :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  include Authority::Abilities

  def self.alpha
    scoped.order("NAME ASC")
  end
end
