require "test_helper"

class ToolTypeTest < ActiveSupport::TestCase

  setup do
    require "#{Rails.root}/db/seeds.rb"
  end

  test "mandate tool type maps for Pulser" do
    #0 - Dual Gamma
    #1 - Pulser Driver
    #3 - Sensor Interface
    #4 - EM

    assert_equal "Pulser Driver", ToolType.for_mandate(PulserMandate.new.tool_type_klass).name
    assert_equal 1, ToolType.for_mandate(PulserMandate.new.tool_type_klass).id

  end

  test "tool types for DualGamma" do
    assert_equal "Dual Gamma", ToolType.for_mandate(DualGammaMandate.new.tool_type_klass).name
    assert_equal 0, ToolType.for_mandate(DualGammaMandate.new.tool_type_klass).id
  end

  test "tool types for Receiver" do
    assert_equal 19, ToolType.find_by(klass: "LeamReceiver").number
    assert_equal "APS EM Receiver",
                 ToolType.find_by(klass: "EmReceiver").description
  end

  test 'description must be unique' do
    type = create( :tool_type )
    new_type = build( :tool_type, description: type.description)
    assert_equal( new_type.valid?, false )
    new_type.description = "a;sldkfj"
    assert_equal( new_type.valid?, true )
  end

  test 'destroy should destroy all associated tools' do
    type = create( :tool ).tool_type
    assert_equal( Tool.count, 1 )
    type.destroy
    assert_equal( Tool.count, 0 )
  end
end
