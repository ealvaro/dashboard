require "test_helper"

class DualGammaLiteMandateTest < ActiveSupport::TestCase
  test "still creates a token" do
    m = DualGammaLiteMandate.new
    m.save(validate: false)
    assert m.public_token.present?
  end

  test "it should be able to set general params" do
    fields = {
      running_avg_window: 123,
      logging_period_in_secs: 130.3
    }

    sim = FactoryGirl.create(:dual_gamma_lite_mandate, fields)

    assert_fields sim, fields
  end

  test "it should respond to tool type klass" do
    assert_equal "DualGammaLite", DualGammaLiteMandate.new.tool_type_klass
  end

  def assert_fields(object, fields)
    fields.each do |k,v|
      assert_equal v, object.reload.send(k)
    end
  end
end
