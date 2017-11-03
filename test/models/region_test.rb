require "test_helper"

class RegionTest < ActiveSupport::TestCase

  test "will not retrieve inactive regions" do
    Region.delete_all
    active = Region.create name: "name-a"
    inactive = Region.create name: "name-b", active: false
    assert_equal [active], Region.active
  end

  test "name has to be unique" do
    Region.create( name: "unique" )
    region = Region.new( name: "unique" )
    region.save
    assert region.errors[:name].select{ |e| e.include?( "taken" ) }.length > 0
  end

  test "name cannot be blank" do
    region = Region.new( name: "" )
    region.save
    assert region.errors[:name].select{ |e| e.include?( "blank" ) }.length > 0
  end
end
