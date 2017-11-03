class Formation < ActiveRecord::Base
  include PgSearch
  has_many :wells

  validates_presence_of :name
  validates_uniqueness_of :name

  # multisearchable :against => [:name]

  pg_search_scope :search,
                :against => [:name],
                :using => {
                  :tsearch => {
                    :prefix => true
                  }
                }

  def multiplier
    read_attribute :multiplier || 1
  end
end
