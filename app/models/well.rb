class Well < ActiveRecord::Base
  include Authority::Abilities
  include HasRemoteOpsUpdates
  include PgSearch

  belongs_to :formation
  has_many :runs, dependent: :destroy
  has_many :rigs, -> { uniq }, through: :runs

  validates :name, presence: true, allow_nil: false, uniqueness: true

  # multisearchable :against => [:name]

  pg_search_scope :search,
                :against => :name,
                :using => {
                  :tsearch => {
                    :prefix => true
                  }
                }

  def self.fuzzy_find(name)
    name.blank? ? nil : Well.find_by("lower(name) = ?", name.downcase.strip)
  end
end
