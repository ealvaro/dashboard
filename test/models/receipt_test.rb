require "test_helper"

class ReceiptTest < ActiveSupport::TestCase

  test "relationship setup correctly" do
    mandate = Mandate.new.tap{|m| m.save(validate: false)}
    r = Receipt.create!(mandate_token: mandate.public_token,
                        tool_serial: "the-serial",
                        timestamp_utc: Time.now.utc,
                       )
    r.reload
    assert_equal mandate, r.mandate
    assert_equal [r], mandate.receipts
  end

  test "requires a mandate" do
    receipt = Receipt.new.tap{|m| m.save(validate: false)}
    receipt.valid?
    assert_equal true, receipt.errors[:mandate_token].any?
  end
end
