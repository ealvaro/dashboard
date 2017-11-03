require "test_helper"

class V744::LoggerUpdatesControllerTest < ActionController::TestCase
  test 'should respond to generic variables' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      update = Update.find JSON.parse(response.body)["id"]
      [:time, :job_number, :software_installation_id, :run_number, :client_name, :rig_name, :well_name, :team_viewer_id,
       :team_viewer_password, :block_height, :hookload, :pump_pressure, :bit_depth, :weight_on_bit, :rotary_rpm,
       :rop, :voltage, :inc, :azm, :api, :hole_depth, :gravity, :dipa, :survey_md, :survey_tvd, :survey_vs,
       :temperature, :pumps_on, :on_bottom, :slips_out].each do |sym|
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

  test 'should set time' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      time = DateTime.now.utc
      post :create, json.merge(time_stamp: time)
      update = Update.find JSON.parse(response.body)["id"]
      assert_equal time.to_i, update.time.to_i
    end
  end

  test 'should create global-based notification when triggered' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      configuration = UpdateNotifier.config_from_string("LoggerUpdate weight_on_bit == 9")
      create(:global_notifier, configuration: configuration)

      assert_difference('Notification.count') do
        post :create, json
      end
    end
  end

  test 'should create rig-based notification when triggered' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      rig = create(:rig, name:"Big rig")
      configuration = UpdateNotifier.config_from_string("LoggerUpdate dipa == 50")
      create(:rig_notifier, notifierable: rig, configuration: configuration)

      assert_difference('Notification.count') do
        post :create, json
      end
    end
  end

  test 'should create group-based notification when triggered' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      rig = create(:rig, name:"Big rig")
      rig_group = create(:rig_group, rigs: [rig])
      configuration = UpdateNotifier.config_from_string("LoggerUpdate survey_vs == 2150")
      create(:group_notifier, notifierable: rig_group,
             configuration: configuration)

      assert_difference('Notification.count') do
        post :create, json
      end
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
      post :create, json.merge({"hookload"=>"55.6"})

      assert_difference('Update.count') do
        post :create, minimal_json
      end

      update = Update.find JSON.parse(response.body)["id"]
      assert_equal 55.6, update.hookload
    end
  end

  def fixture_path
    "#{Rails.root}/test/fixtures/active_jobs/"
  end

  def decode_json_file(file)
    json = File.read(file)
    ActiveSupport::JSON.decode(json).merge(time_stamp: DateTime.now.utc)
  end

  def json
    @json ||= decode_json_file(fixture_path + "logger.json")
  end

  def minimal_json
    @minimal_json ||= decode_json_file(fixture_path + "logger_min.json")
  end

  def good_token
    "teh-good-token"
  end
end
