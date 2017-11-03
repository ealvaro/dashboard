require "test_helper"

class BillableRunTest < ActiveSupport::TestCase
  test "should pull the correct values" do
    rr = create( :run_record, chlorides: 500 )
    assert_equal 500, rr.run.chlorides_as_billed
    rr.run.update_attributes chlorides_as_billed: 1000
    assert_equal 1000, rr.run.chlorides_as_billed
  end

  %i( max_temperature
      item_start_hrs
      circulating_hrs
      rotating_hours
      sliding_hours
      total_drilling_hours
      mud_weight
      gpm
      bit_type
      motor_bend
      rpm
      chlorides
      sand
      brt
      art
      bha
      agitator_distance
      mud_type
      agitator ).each do |attr|
    test "#{attr} should be defined" do
      Run.new().respond_to?( attr )
    end
  end

end
