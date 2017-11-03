require "test_helper"

class DualGammaLiteMandateSerializerTest < ActiveSupport::TestCase
  test "it should set all basic attributes correctly" do
    fields = {
      running_avg_window: 123,
      logging_period_in_secs: 5.1,
    }


    json = DualGammaLiteMandateSerializer.new(FactoryGirl.create(:dual_gamma_lite_mandate, fields), root: false).as_json

    fields.each do |k,v|
      assert_equal v, json[k], "Failed to set #{k}"
    end
  end
end
