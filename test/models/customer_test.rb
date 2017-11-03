require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test 'email should be unique disregaurding case' do
    c = create( :customer )
    c2 = build( :customer, email: c.email.upcase )
    assert( c2.valid?, false )
    c2.email = "new@email.com"
    c2.save!
    assert_equal( c2.valid?, true )
  end

  test 'email must be valid' do
    c = build( :customer )
    c.email = "@"
    assert( c.valid?, false )
    c.email = "1@1"
    assert( c.valid?, false )
    c.email = "@.com"
    assert( c.valid?, false )
    c.email = "a@.com"
    assert( c.valid?, false )
  end
end
