require "test_helper"

class RunTest < ActiveSupport::TestCase
  test 'factory should create a vaild run' do
    run = create( :run )
    assert( run.valid? )
  end

  test 'destroy should destroy run records' do
    run = create( :run_record ).run
    assert_equal( RunRecord.count, 1 )
    run.destroy
    assert_equal( RunRecord.count, 0 )
  end

  test 'occurred can not be in the future' do
    run = build( :run , occurred: DateTime.now + 1.day )
    assert_equal( run.valid?, false )
  end

  test 'should accurately store number attribute' do
    assert_equal( 65, create( :run, number: 65 ).number )
  end


  test 'should cleanup invoice data correctly' do
    run = create( :run )
    run.update_attributes! max_temperature_as_billed: 1,
                           max_shock_as_billed: 1,
                           max_vibe_as_billed: 1,
                           shock_warnings_as_billed: 1,
                           item_start_hrs_as_billed: 1,
                           circulating_hrs_as_billed: 1,
                           rotating_hours_as_billed: 1,
                           sliding_hours_as_billed: 1,
                           total_drilling_hours_as_billed: 1,
                           mud_weight_as_billed: 1,
                           gpm_as_billed: 1,
                           bit_type_as_billed: 1,
                           motor_bend_as_billed: 1,
                           rpm_as_billed: 1,
                           chlorides_as_billed: 1,
                           sand_as_billed: 1,
                           brt_as_billed: DateTime.now,
                           art_as_billed: DateTime.now,
                           bha_as_billed: 1,
                           agitator_distance_as_billed: 1,
                           mud_type_as_billed: 1,
                           agitator_as_billed: 1,
                           invoice_id: 1234
    assert_equal 1, run.agitator_as_billed
    assert_equal 1234, run.invoice_id
    run.cleanup_invoice_destroy!
    assert_equal nil, run.agitator_as_billed
    assert_equal nil, run.invoice_id
  end

end
