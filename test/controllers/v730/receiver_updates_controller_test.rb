require "test_helper"

class V730::ReceiverUpdatesControllerTest < ActionController::TestCase
  include ReceiverUpdatesControllerTestHelper

  test 'should respond to generic variables' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      [
        :dao, :reporter_version, :software_installation_id, :team_viewer_id, :team_viewer_password,
        :decode_percentage, :pump_on_time, :pump_off_time, :pump_total_time, :inc, :azm, :gravity, :magf, :dipa,
        :gama, :atfa, :gtfa, :mtfa, :mx, :my, :mz, :ax, :ay, :az, :batv, :batw, :dipw, :gravw, :gv0, :gv1,
        :gv2, :gv3, :gv4, :gv5, :gv6, :gv7, :magw, :tempw, :sync_marker, :survey_sequence, :logging_sequence,
        :confidence_level, :average_quality, :pump_state, :tf
      ].each do |sym|
        assert_equal false, receiver_update.send(sym).nil?, sym.to_s
      end
    end
  end

  test 'should assign job, run, well, client, rig' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert receiver_update.run.present?
      assert receiver_update.run.job.present?
      assert receiver_update.run.rig.present?
      assert receiver_update.run.well.present?
      assert receiver_update.run.job.client.present?
    end
  end

  test 'should set temperature' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(temp: 310)
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal 310, receiver_update.temperature
    end
  end

  test 'should set low pulse threshold' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(low_pulse_threshold: 10)
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal 10, receiver_update.low_pulse_threshold
    end
  end

 test 'should set average pulse' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(average_pulse: 1.23)
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal 1.23, receiver_update.average_pulse
    end
  end

  test 'should set tool face data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal 5, receiver_update.tool_face_data.length
    end
  end

  test 'should set pulse data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal 3, receiver_update.pulse_data.length
    end
  end

  test 'should set table data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal 3, receiver_update.table.length
    end
  end

  test 'should set the receiver type to leam receiver' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(receiver_type: 'leam-receiver')
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal "LeamReceiverUpdate", receiver_update.class.name
    end
  end

  test 'should set the receiver type to btr receiver' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(receiver_type: 'btr-receiver')
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal "BtrReceiverUpdate", receiver_update.class.name
    end
  end

  test 'should set the receiver type to em receiver' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(receiver_type: 'em-receiver')
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal "EmReceiverUpdate", receiver_update.class.name
    end
  end

  test 'should set the receiver type to btr control receiver' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(receiver_type: 'btr-control-receiver')
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal "BtrControlUpdate", receiver_update.class.name
    end
  end

  test 'should reject invalid job' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(job:'unknown')

      assert_response :bad_request
    end
  end

  test 'should create notification when triggered' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      configuration = UpdateNotifier.config_from_string("LeamReceiverUpdate inc > 1")
      create(:global_notifier, configuration: configuration)

      assert_difference('Notification.count') do
        post :create, json
      end
    end
  end

  test 'should provide complex notifier description from updates' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      configuration = ActiveSupport::JSON.decode( File.read("#{Rails.root}/test/fixtures/notifiers/configuration.json"))
      notifier = create(:global_notifier, configuration: configuration)

      post :create, json
      post :create, json.merge(receiver_type: 'btr-receiver')
      post :create, json.merge(receiver_type: 'btr-control-receiver')

      assert_equal "LRx Gama: 20.66, BTR Monitor Ax: 13.74, BTR Control Ay: 18.25, LRx Az: 18.05, LRx Batw: true",
                   Notification.active.last.description
    end
  end

  test 'should update rig updated_at' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      rig = create :rig, updated_at: 10.minutes.ago
      post :create, json.merge({"rig" => rig.name})
      assert Rig.last.updated_at.to_i != rig.updated_at.to_i
    end
  end

  test 'should handle pump_off_time overflow with bad request' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge({"pump_off_time": "54978118000"})

      assert_response :bad_request
    end
  end

  test 'should allow empty pump_off_time' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge({"pump_off_time": nil})

      assert_response :ok
    end
  end
end
