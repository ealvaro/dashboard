require "test_helper"

class V730::LoggerUpdatesControllerTest < ActionController::TestCase
  test 'should respond to generic variables' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      logger_update = LoggerUpdate.find JSON.parse(response.body)["id"]
      [:time, :job_number, :software_installation_id, :run_number, :client_name, :rig_name, :well_name, :team_viewer_id,
       :team_viewer_password, :block_height, :hookload, :pump_pressure, :bit_depth, :weight_on_bit, :rotary_rpm,
       :rop, :voltage, :inc, :azm, :api, :hole_depth, :gravity, :dipa, :survey_md, :survey_tvd, :survey_vs,
       :temperature, :pumps_on, :on_bottom, :slips_out, :reporter_version].each do |sym|
        assert_equal false, logger_update.send(sym).nil?, sym.to_s
      end
    end
  end

  test 'should assign job, run, well, client, rig' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json
      logger_update = LoggerUpdate.find JSON.parse(response.body)["id"]
      assert logger_update.run.present?
      assert logger_update.run.job.present?
      assert logger_update.run.rig.present?
      assert logger_update.run.well.present?
      assert logger_update.run.job.client.present?
    end
  end

  test 'should set time' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      time = DateTime.now.utc
      post :create, json.merge(time_stamp: time)
      logger_update = LoggerUpdate.find JSON.parse(response.body)["id"]
      assert_equal time.to_i, logger_update.time.to_i
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

  def json
    @json ||= ActiveSupport::JSON.decode( File.read("#{Rails.root}/test/fixtures/active_jobs/logger.json")).merge(time_stamp: DateTime.now.utc)
  end

  def good_token
    "teh-good-token"
  end
end
