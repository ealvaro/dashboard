require "test_helper"

class V760::ReceiverUpdatesControllerTest < ActionController::TestCase
  include ReceiverUpdatesControllerTestHelper

  test 'should set core data' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create_core, json
      update = Update.find JSON.parse(response.body)["id"]

      assert update.run.present?
      assert update.run.job.present?
      assert update.dao.present?
    end
  end

  test 'should not set pulse or fft' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create_core, json
      update = Update.find JSON.parse(response.body)["id"]

      assert update.pulse_data.blank?, "pulse data is not blank"
      assert update.fft.blank?, "fft is not blank"
    end
  end

  test 'should set pulse separately' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create_core, json

      post :create_pulse,
           {
             "job"=>"OK-140504", "run"=>"2",
             "time_stamp": "2015-02-04 22:13:32 UTC",
             "pulse_start_time": "1441256822062",
             "sample_rate"=>10, "pulses"=>[10, 20, 30],
             "low_pulse_threshold"=>8
           }
      update = Update.find JSON.parse(response.body)["id"]

      assert_equal 3, update.pulse_data.count
      refute update.low_pulse_threshold.blank?, "low pulse threshold is blank"
    end
  end

  test 'should not set pulse at all' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create_core, json
      post :create_pulse,
           {
             "job"=>"OK-140504", "run"=>"2",
             "time_stamp": "2015-02-04 22:13:32 UTC",
             "pulse_start_time": "1441256822062",
             "sample_rate"=>10, "pulses"=>[10, 20, 30]
           }

      post :create_core, json
      update = Update.find JSON.parse(response.body)["id"]

      assert update.pulse_data.blank?, "pulse data is not blank"
    end
  end

  test 'should set fft separately' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create_core, json

      post :create_fft,
           {
             "job"=>"OK-140504", "run"=>"2",
             "time_stamp":"2015-02-04 22:13:32 UTC",
             "fft"=>[{"freq"=>"0", "ampl"=>"0"}]
           }
      update = Update.find JSON.parse(response.body)["id"]

      refute update.fft.blank?, "fft is blank"
    end
  end

  test 'saves compressed pulse data correctly' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      time_stamp = 1441256822062
      values = [0, 1]
      post :create_core, json
      post :create_pulse,
           {
             "job"=>"OK-140504", "run"=>"2",
             "time_stamp":"2015-02-04 22:13:32 UTC",
             "pulse_start_time":time_stamp,
             "sample_rate"=>0, "pulses"=>values
           }

      update = Update.find JSON.parse(response.body)["id"]
      expected = { "time_stamp" => time_stamp,
                   "sample_rate" => 10.to_f,
                   "values" => values.map { |v| "#{v}" } }
      assert_equal update.pulse_data, expected
    end
  end
end
