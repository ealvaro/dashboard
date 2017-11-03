class Client < ActiveRecord::Base
  include Authority::Abilities
  include HasRemoteOpsUpdates
  include PgSearch
  before_create :set_defaults

  has_many :customers, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :pricing_schemes, dependent: :destroy

  scope :visible, -> { where("hidden != true") }

  validates_presence_of :name

  # multisearchable :against => [:name, :zip_code, :address_street, :address_city, :country, :address_state]

  pg_search_scope :search,
                :against => [:name, :zip_code, :address_street, :address_city, :country, :address_state],
                :using => {
                  :tsearch => {
                    :prefix => true
                  }
                }

  def self.search keywords
    if keywords.present?
      where("name ilike :k OR
      address_street ilike :k OR
      address_city ilike :k OR
      zip_code ilike :k OR
      country ilike :k OR
      address_state ilike :k", k: "%#{keywords}%")
    end
  end

  def self.fuzzy_find(name)
    Client.find_by("lower(name) = ?", name.downcase.strip)
  end

  def pricing
    self.pricing_schemes.last
  end

  private

  def set_defaults
    #maintains defaults for change over time
    self.pricing_schemes.build DefaultPricingScheme.where("type is null" ).last.attributes.reject {|k,v| k == "id"} unless DefaultPricingScheme.count == 0
  end
end
