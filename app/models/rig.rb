class Rig < ActiveRecord::Base
  include Authority::Abilities  
  include PgSearch
  has_many :wells, -> { uniq }, through: :runs
  has_many :runs
  has_many :updates
  has_and_belongs_to_many :rig_groups

  multisearchable :against => [:name]

  scope :active, -> { where("updated_at > ?", 7.days.ago).order(updated_at: :desc) }

  validates_presence_of :name

  def self.fuzzy_find(name)
    return [] unless name
    Rig.find_by("lower(name) = ?", name.downcase.strip)
  end
end
