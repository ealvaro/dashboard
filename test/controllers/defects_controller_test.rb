require "test_helper"

class DefectsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :redirect
  end

end
