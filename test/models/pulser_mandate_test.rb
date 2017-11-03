require "test_helper"

class PulserMandateTest < ActiveSupport::TestCase

  test "still creates a token" do
    m = PulserMandate.new
    m.save(validate: false)
    assert m.public_token.present?
  end

  test "highs and lows" do
    range_test_for(:vib_trip_hi, min: 10, max: 300)
    range_test_for(:vib_trip_lo, min: 1, max: 50)
    range_test_for(:vib_trip_hi_a, min: 50, max: 500)
    range_test_for(:vib_trip_lo_a, min: 1, max: 250)
  end

  def range_test_for(attr, min:0, max:500)
    # passes
    [min, max].each do |i|
      m = PulserMandate.new
      m.send("#{attr}=", i)
      m.valid?
      assert_equal false, m.errors[attr].any?, [attr, min, max].join(",")
    end

    #fails outside
    [min-1, max+1].each do |i|
      m = PulserMandate.new
      m.send("#{attr}=", i)
      m.valid?
      assert_equal true, m.errors[attr].any?
    end
  end

  test "Vib Trip Hi must be higher and not equal to Vib Trip Lo" do
    [60, 50].each do |lo|
      m = PulserMandate.new
      m.vib_trip_hi = 50
      m.vib_trip_lo = lo
      m.valid?
      assert_equal true, m.errors[:vib_trip_hi].any?, "Lo value: #{lo}"
    end
  end

  test "Vib Trip Hi A must be higher and not equal to Vib Trip Lo A" do
    [60, 50].each do |lo|
      m = PulserMandate.new
      m.vib_trip_hi_a= 50
      m.vib_trip_lo_a= lo
      m.valid?
      assert_equal true, m.errors[:vib_trip_hi_a].any?, "Lo value: #{lo}"
    end
  end

  test "Flow switch thresholds must all be filled if one threshold is" do
    m = PulserMandate.new
    m.flow_switch_threshold_strongly_on_high = 1.0
    m.valid?
    assert_equal true, m.errors[:flow_switch_threshold_strongly_on_analog].any?
    assert_equal true, m.errors[:flow_switch_threshold_strongly_on_digital].any?
    assert_equal true, m.errors[:flow_switch_threshold_weakly_on_high].any?
    assert_equal true, m.errors[:flow_switch_threshold_weakly_on_analog].any?
    assert_equal true, m.errors[:flow_switch_threshold_weakly_on_digital].any?
    assert_equal true, m.errors[:flow_switch_threshold_off_high].any?
    assert_equal true, m.errors[:flow_switch_threshold_off_analog].any?
    assert_equal true, m.errors[:flow_switch_threshold_off_digital].any?
  end

  def create_mandate args
    PulserMandate.new(args).tap{|m| m.save(validate: false)}
  end
end
