module BillableInvoice
  extend ActiveSupport::Concern

  def multiplier_as_billed
    read_attribute( :multiplier_as_billed ) || 1.0
  end

  def discount_percent_as_billed
    read_attribute( :discount_percent_as_billed ) || 0.0
  end
end
