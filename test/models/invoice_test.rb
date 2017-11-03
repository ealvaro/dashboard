require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "should initialize with a status of new" do
    assert_equal("new", build(:invoice).status)
  end

  test "should not be valid without a status" do
    invoice = build(:invoice)
    invoice.status = ""
    assert(!invoice.valid?)
    invoice.status = "new"
    assert(invoice.valid?)
  end

  test "should have the available statuses of 'new' 'draft' and 'complete'" do
    assert_equal( %w(new draft complete), Invoice.new.send(:available_statuses) )
  end

  test "should not be valid with a discount percentage greater than 100" do
    assert(!build(:invoice, discount_percent_as_billed: 200).valid?)
  end

  test "should not be valid with a discount percentage less than 0" do
    assert(!build(:invoice, discount_percent_as_billed: -2).valid?)
  end

  test "should be valid with a discount percentage equal to 100" do
    assert(build(:invoice, discount_percent_as_billed: 100).valid?)
  end

  test "should be valid with a discount percentage equal to 0" do
    assert(build(:invoice, discount_percent_as_billed: 0).valid?)
  end
end
