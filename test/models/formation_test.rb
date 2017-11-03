require "test_helper"

class FormationTest < ActiveSupport::TestCase
  test "should persist a formation multiplier" do
    assert_equal 1.1, create( :formation, multiplier: 1.1 ).multiplier
  end
end
