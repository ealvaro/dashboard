require "test_helper"

class V744::ReceiverUpdatesControllerTest < ActionController::TestCase
  include ReceiverUpdatesControllerTestHelper

  test 'should respond to generic variables' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      update = Update.find JSON.parse(response.body)["id"]
      [
        :dao, :reporter_version, :software_installation_id, :team_viewer_id, :team_viewer_password,
        :decode_percentage, :pump_on_time, :pump_off_time, :pump_total_time, :inc, :azm, :gravity, :magf, :dipa,
        :gama, :atfa, :gtfa, :mtfa, :mx, :my, :mz, :ax, :ay, :az, :batv, :batw, :dipw, :gravw, :gv0, :gv1,
        :gv2, :gv3, :gv4, :gv5, :gv6, :gv7, :magw, :tempw, :sync_marker, :survey_sequence, :logging_sequence,
        :confidence_level, :average_quality, :pump_state, :tf
      ].each do |sym|
        assert_equal false, update.send(sym).nil?, sym.to_s
      end
    end
  end

  test 'should assign job, run, well, client, rig' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      update = Update.find JSON.parse(response.body)["id"]
      assert update.run.present?
      assert update.run.job.present?
      assert update.run.rig.present?
      assert update.run.well.present?
      assert update.run.job.client.present?
    end
  end

  test 'should set temperature' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(temp: 310)
      update = Update.find JSON.parse(response.body)["id"]
      assert_equal 310, update.temperature
    end
  end

  test 'should set low pulse threshold' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(low_pulse_threshold: 10)
      update = Update.find JSON.parse(response.body)["id"]
      assert_equal 10, update.low_pulse_threshold
    end
  end

  test 'should set tool face data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      update = Update.find JSON.parse(response.body)["id"]
      assert_equal 5, update.tool_face_data.length
    end
  end

  test 'should uncompress the pulse data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      pulse_data = {"time_stamp"=>"1441256822062",
                    "values"=>[0, 1, 2, 4]}

      post :create, minimal_json.merge({"compressed_pulse_data"=>pulse_data})

      update = Update.find JSON.parse(response.body)["id"]
      assert 4, update.pulse_data.length
    end
  end

  test 'should set table data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      update = Update.find JSON.parse(response.body)["id"]
      assert_equal 3, update.table.length
    end
  end

  test 'should set the receiver type to leam receiver' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(receiver_type: '')
      update = Update.find JSON.parse(response.body)["id"]
      assert_equal "LeamReceiverUpdate", update.class.name
    end
  end

  test 'should set the receiver type to btr receiver' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(receiver_type: 'btr-receiver')
      update = Update.find JSON.parse(response.body)["id"]
      assert_equal "BtrReceiverUpdate", update.class.name
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

  test 'should copy previous information' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:job, name: json["job"])
      post :create, json.merge({'gama'=>'1.23'})

      assert_difference('Update.count') do
        post :create, minimal_json
      end

      update = Update.find JSON.parse(response.body)["id"]
      assert_equal 1.23, update.gama
    end
  end

  test 'should not copy previous information if run changed' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:job, name: json["job"])
      post :create, json

      assert_difference('Update.count') do
        post :create, minimal_json.merge({'run'=>'45'})
      end

      update = Update.find JSON.parse(response.body)["id"]
      assert update.gama.blank?
    end
  end

  test 'should copy previous pulse data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:job, name: json["job"])
      post :create, json

      post :create, minimal_json.merge({time_stamp: DateTime.now.utc + 2.seconds})

      update = Update.find JSON.parse(response.body)["id"]
      refute update.pulse_data.blank?, "pulse data is blank"
      refute_equal Update.all[-2].time, Update.all[-1].time
      refute_equal Update.all[-2].published_at, Update.all[-1].published_at
      refute_equal nil, Update.all[-1].published_at
    end
  end

  test 'should not set temperature if nil' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge(temp: 310)
      post :create, json.merge(temp: nil)
      receiver_update = ReceiverUpdate.find JSON.parse(response.body)["id"]
      assert_equal 310, receiver_update.temperature
    end
  end
end
