require "test_helper"

class Push::InstallsControllerTest < ActionController::TestCase

  test "will create install with new key" do
    params = sample_json
    post :create, params.merge(format: :json)
    json = JSON.parse(response.body)
    assert_response :success
    assert json["key"], "Key was missing"
  end

  test "responds with errors when missing" do
    params = sample_json
    params["install"].delete_if{ |k,v| k == 'version' }
    post :create, params.merge(format: :json)
    json = JSON.parse(response.body)
    assert_response 422
    assert json["errors"].any?, "Should have errors"
  end

  test "responds with errors when not using install" do
    params = {}
    post :create, params.merge(format: :json)
    json = JSON.parse(response.body)
    assert_response 422
    assert json["errors"].any?, "Should have errors"
  end

  test "will update an existing Install Date" do
    params = sample_json
    install = Install.create!(params["install"].merge("ip_address"=>"127.0.0.1"))
    key = install.key
    params["install"]["key"] = key
    post :create, params.merge(format: :json)
    new = Install.find_by key: install.key
    assert new.updated_at > install.updated_at
  end

  test "will update an existing Install Version" do
    params = sample_json
    install = Install.create!(params["install"].merge("ip_address"=>"127.0.0.1"))
    key = install.key
    params["install"]["key"] = key
    params["install"]["version"] = "35.0.0"
    post :create, params.merge(format: :json)
    new = Install.find_by key: install.key
    assert_equal "35.0.0", new.version
  end

  test "will store with all attributes" do
    params = sample_json
    post :create, params.merge( format: :json )
    json = JSON.parse( response.body )
    assert_response 201
  end

  test "will store Dell Service Number" do
    assert_equal "snarky", sample_json["install"]["dell_service_number"]
    params = sample_json
    post :create, params.merge( format: :json )
    assert_equal "snarky", Install.last.dell_service_number
  end

  test "will store the computer category correctly" do
    assert_equal "Logging", sample_json["install"]["computer_category"]
    params = sample_json
    post :create, params.merge( format: :json )
    assert_equal "Logging", Install.last.computer_category
  end

  def sample_json
    ActiveSupport::JSON.decode( File.read("#{Rails.root}/test/fixtures/installs/sample.json") )
  end
end
