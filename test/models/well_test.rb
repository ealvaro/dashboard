require "test_helper"

class WellTest < ActiveSupport::TestCase
  test 'destroy should destroy runs' do
    well = create( :run ).well
    assert_equal( Run.count, 1 )
    well.destroy
    assert_equal( Run.count, 0 )
  end
end
