class Damage < ActiveRecord::Base
  belongs_to :run

  validates :amount_in_cents_as_billed, presence: true
  validates :run, presence: true
end
