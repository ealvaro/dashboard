class Receipt < ActiveRecord::Base
  validates_presence_of :timestamp_utc
  validates_presence_of :tool_serial

  validate do |record|
    if record.mandate_token.blank?
      record.errors.add(:mandate_token, "is invalid {mandate missing}") 
    end
  end

  def self.for_token token
    where(mandate_token: token)
  end

  def mandate
    Mandate.by_public_token(mandate_token)
  end

end
