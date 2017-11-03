require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test 'Destroying a client should destroy all customers' do
    create( :customer )
    Client.first.destroy
    assert_equal( Customer.count, 0 )
  end

  test 'destory should destory jobs' do
    client = create( :job ).client
    assert_equal( Job.count, 1 )
    client.destroy
    assert_equal( Job.count, 0 )
  end

  test 'should copy the current default to its pricing schemes and use the last one' do
    PricingScheme.destroy_all
    client = create(:pricing_scheme).client
    assert_equal 2, PricingScheme.count
    assert_equal PricingScheme.last.id, client.pricing.id
  end

  test 'should update pricing schemes' do
    pricing = create(:pricing_scheme)
    client = pricing.client
    client.pricing_schemes << create(:pricing_scheme)
    assert_not_equal client.pricing.id, PricingScheme.first.id
    assert_equal client.pricing.id, PricingScheme.last.id
  end
end

