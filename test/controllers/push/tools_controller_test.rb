require "test_helper"

class Push::ToolsControllerTest < ActionController::TestCase

  test "missing headers get 401" do
    post :create, {format: :json}
    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = bad_token
      post :create, {format: :json}
      assert_response 401
    end
  end

  test "with header get 200 and json" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      post :create, {tool_type: 0, format: :json}
      assert_response :success
    end
  end

  test "record event" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      start_count = tool.events.count
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal start_count + 1, tool.events.count
    end
  end

  test "should not record event without UID" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    sample_json.delete("uid")

    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'

      assert_response :bad_request
    end
  end

  test "create a client job run and rig if correctly given" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    sample_json.merge!( "client_name" => "Apache", "job_number" => "OK-1234", "run_number" => 1 )
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      start_count = tool.events.count
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_equal "Apache", Client.last.name
      assert_equal "OK-1234", Job.last.name
      assert_equal 1, Run.last.number
    end
  end

  test "created event should have the correct mem usage lvl and hardware version" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      start_count = tool.events.count
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal start_count + 1, tool.events.count
    end
    Tool.last.events.last.tap do |e|
      assert_equal( e.memory_usage_level,"12%" )
      assert_equal( e.hardware_version, "v1.2.3.4" )
    end
  end

  test "record multiple assets" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal 3 , tool.events.last.event_assets.count
      assert_equal 3 , tool.events.last.event_assets.map(&:file).compact.count
    end
  end

  test "record asset name and file" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success

      asset = tool.events.last.event_assets.first
      assert_not_nil asset.name
      assert_not_nil asset.file
    end
  end

  test "record job number" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success

      event = tool.events.last
      assert_not_nil event.job_number
    end
  end

  test "record run number" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success

      event = tool.events.last
      assert_not_nil event.run_number
    end
  end

  test "record reporter context" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success

      event = tool.events.last
      assert_not_nil event.reporter_context
    end
  end

  test "record tags" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success

      event = tool.events.last
      assert_equal event.tags, {"crossover"=>"true", "shock"=>"4"}
    end
  end

  test "record max shock, max temperature and shock count" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success

      event = tool.events.last
      assert_equal event.max_temperature, 1.0
      assert_equal event.max_shock, 2.0
      assert_equal event.shock_count, 3
    end
  end

  test "return uid unformatted" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      get :index
      assert_equal( "04d68abd", JSON.parse( response.body ).first["uid"] )
    end
  end

  test "record configs" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal 2, tool.events.last.configs.keys.count
      assert_equal ["key", "second_key"], tool.events.last.configs.keys
      assert_equal ["value", "second_value"], tool.events.last.configs.values
    end
  end

  test "404's if id missing" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :show, {id: 40, format: :json}
      assert_response 404
    end
  end

  test "200 tool with serial number exists" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(tool_type_id: 1, serial_number: '1234')
      get :show, {id: '1234', serial_number: '1234', format: :json}
      assert_equal tool.id, JSON.parse(response.body)["tool"]["id"]
    end
  end

  test "the serial number should be findable" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(tool_type_id: 1, serial_number: '1234')
      get :show, {id: '1234', serial_number: '1234', format: :json}
      assert_equal tool.serial_number, JSON.parse(response.body)["tool"]["serial_number"]
    end
  end

  test "200 if exists" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(tool_type_id: 1)
      get :show, {id: tool.uid, format: :json}
    end
  end

  test "should set serial number on create if supplied" do
    sample_json = {tool_type: 5, serial_number: '1234'}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal '1234', Tool.last.serial_number
    end
  end

  test "should record events for dumb tools" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample_dumb_tool.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      event_count = Event.count
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.find_by!(number: 5).id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert event_count + 1, Event.count
    end
  end

  test "should correctly upload reports" do
    rt = create(:report_type, name: "Report A")
    dash = Tool.create!(uid: 'sampleuid', tool_type: ToolType.find_by!(number:6))
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/report_upload.json")
    sample_json.merge!("report_type_id" => rt.id)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      event_count = Event.count
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert event_count + 1, Event.count
    end
  end

  test "should be able to find by report type or event" do
    rt = create(:report_type, name: "Report A")
    dash = Tool.create!(uid: 'sampleuid', tool_type: ToolType.find_by!(number:6))
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/report_upload.json")
    sample_json.merge!("report_type_id" => rt.id)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_equal Event.last.id, rt.events.last.id
      assert_equal Event.last.report_type.id, rt.id
    end
  end

  test "should be able to find by run" do
    rt = create(:report_type, name: "Report A")
    run = create(:run)
    dash = Tool.create!(uid: 'sampleuid', tool_type: ToolType.find_by!(number:6))
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/report_upload.json")
    sample_json.merge!("report_type_id" => rt.id, "run_number" => run.number, "job_number" => run.job.name)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_equal run.events.last, Event.last
    end
  end

  test "record team viewer creds" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = Tool.create!(uid: "04d68abd", tool_type_id: ToolType.first.id)
      post :events, sample_json, "CONTENT_TYPE" => 'application/json'
      event = Event.last
      assert_equal event.team_viewer_id, "TVID"
      assert_equal event.team_viewer_password, "TVPASSWORD"
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end
end
