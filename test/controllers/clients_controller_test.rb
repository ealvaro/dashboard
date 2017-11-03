require "test_helper"

class ClientsControllerTest < ActionController::TestCase
  setup do
    admin = create(:user, roles: ['Admin'])
    session[:user_id] = admin.id
  end

  test "can ignore client" do
    client = create(:client)

    put :ignore, id: client.id

    client = Client.find(client.id)
    assert_equal true, client.hidden
    assert_redirected_to clients_path
  end
end
