class PricingScheme < DefaultPricingScheme
  belongs_to :client

  validates :client, presence: true
end