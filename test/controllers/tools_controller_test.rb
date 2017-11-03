require "test_helper"

class ToolsControllerTest < ActionController::TestCase

  setup do
    @user = create :user
    session[:user_id] = @user.id
  end

  test 'can get histograms' do
    tool = create(:tool)
    @controller.stub(:current_user, @user) do
      get 'histograms', id: tool.id
      assert_response 200
      assert_not_nil assigns(:tool)
      assert_not_nil assigns(:histograms)
    end
  end

end