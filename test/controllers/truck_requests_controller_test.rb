require "test_helper"

class TruckRequestsControllerTest < ActionController::TestCase
  test 'can get index' do
    get :index
    assert_response 200
  end
end
