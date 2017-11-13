require 'http'

class TestLogger
  include TestHelpers

  def initialize(job)
    @job = job
  end

  def url
    if Rails.env.development?
      "http://localhost:3000/v730/logger_updates"
    else
      "http://tracker-wolf.herokuapp.com/v730/logger_updates"
    end
  end

  def publish_notify
    call_api(url, new_data)
  end

  def new_data
    {
      time_stamp: Time.now.utc.to_s,
      receiver_type: "logger",
      reporter_version: "2.1.1",
      job: @job.name, #"OK-140504",
      run: "2",
      client: "Client",
      rig: "Big rig",
      well: "Well",
      team_viewer_id: "1234567",
      team_viewer_password: "CATCATCAT",

      block_height: 100 + rand(200) / 100.0,
      hookload: 220 + rand(500) / 100.0,
      pump_pressure: 1300 + rand(50000) / 1000.0,
      bit_depth: 14000 + rand(10000) / 100.0,
      weight_on_bit: 9 + rand(100) / 100.0,
      rotary_rpm: 0.0,

      rop: 65 + rand(1000) / 100.0,
      voltage: 30 + rand(1000) / 100.0,
      inc: rand(3000) / 1000.0,
      azm: rand(3000) / 1000.0,
      api: 50 + rand(200) / 100.0,
      hole_depth: 14000 + rand(10000) / 100.0,
      formation_resistance: rand(10) / 1.1,
      delta_mtf: rand(300) / 10.0,
      gravity: rand(300) / 10.0,
      dipa: 50 + rand(1000) / 100.0,
      survey_md: 14000 + rand(10000) / 100.0,
      survey_tvd: 11900 + rand(10000) / 100.0,
      survey_vs: 2150 + rand(10000) / 100.0,
      temperature: 262 + rand(10),

      com3: "Good",
      com6: "Good",
      pumps_on: "Y",
      on_bottom: "Y",
      slips_out: "N",
      livelog: "Y"
    }

  end
end
