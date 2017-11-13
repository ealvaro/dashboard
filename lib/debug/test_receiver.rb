require 'http'

class TestReceiver
  include TestHelpers

  def initialize(job)
    @job = job
  end

  def url
    if Rails.env.development?
      "http://localhost:3000/"
    else
      "http://tracker-wolf.herokuapp.com/"
    end
  end

  def publish_notify(receiver_prefix, type = "core", version = "730")
    # receiver_prefix: leam, btr, em
    # type: core, fft, pulse
    # version: 730, 731, 744, 760
    data = common_data("#{receiver_prefix}-receiver")
    case type
    when "fft"
      data.merge! fft_data
    when "pulse"
      data.merge! pulse_data(receiver_prefix, version)
    else # "core"
      data.merge! core_data
      data.merge! pulse_data(receiver_prefix, version) unless version == "760"
    end
    puts data.to_json

    kind = version == "760" ? "#{type}_" : ""
    call_api(url + "v#{version}/receiver_#{kind}updates", data)
  end

  def common_data(receiver_type)
    {
      time_stamp: Time.now.utc.to_s,
      receiver_type: receiver_type,
      job: @job.name, #"OK-140504",
      run: "2"
    }
  end

  def pulse_data(receiver_prefix, version)
    if version == "730" || version == "731"
      {pulse_data: old_pulse_data}
    else
      data = compressed_pulse_data(receiver_prefix == 'em' ? 200 : 3)
      if version == "744"
        {compressed_pulse_data: data}
      else
        {
          sample_rate: data[:sample_rate],
          pulses: data[:values],
          low_pulse_threshold: 8
        }
      end
    end
  end

  def fft_data
    values =
      [
        1, 1, 2, 1, 3, 4, 5, 6, 8, 8, 11, 15, 15, 17, 20, 24, 24, 24, 60,
        90, 74, 41, 24, 11, 5, 5, 4, 4, 2, 2, 2, 1, 2, 3, 2, 1, 1, 1, 2,
        1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1,
        1, 2, 1, 1,
      ]
    fft = values.map.with_index do |value, index|
      {freq: index, ampl: rand(value)}
    end

    # zeros aren't reported but should show up on the UI
    {fft: fft.select { |x| x[:ampl].nonzero? }}
  end

  def standard_rand
    rand(300) / 10.0
  end

  def core_data
    millis = (Time.now.to_f * 1000 ).to_i - (Time.parse( Date.today.to_s(:db)).to_f * 1000).to_i

    @tf_data = tool_face_data

    {
      dao: standard_rand / 10.0,
      client: "Client",
      rig: "Big rig",
      well: "Well",
      team_viewer_id: "1234567",
      team_viewer_password: "CATCATCAT",
      decode_percentage: (standard_rand / 10.0).to_s,
      battery_number: rand(3) + 1,
      dl_power: 0,
      power: rand(300) / 250.0,
      frequency: standard_rand,
      formation_resistance: rand(10) / 1.1,
      signal: rand(3000) / 10.0,
      noise: rand(900) / 3.0,
      mag_dec: rand(10) / 2.0,
      s_n_ratio: rand(10) / 2.0,
      bit_depth: 14000 + rand(1000) / 10.0,
      hole_depth: 14000 + rand(1000) / 10.0,
      pump_on_time: millis,
      pump_off_time: millis,
      pump_total_time: millis,
      inc: standard_rand / 10.0,
      azm: standard_rand / 10.0,
      gravity: standard_rand,
      grav_roll: standard_rand,
      mag_roll: -standard_rand,
      magf: standard_rand,
      dipa: standard_rand,
      temp: standard_rand,
      gama: standard_rand,
      gamma_shock: rand(60) / 10.0,
      gamma_shock_axial_p: rand(100) / 10.0,
      gamma_shock_tran_p: rand(30) / 10.0,
      atfa: standard_rand,
      gtfa: standard_rand,
      mtfa: standard_rand,
      delta_mtf: standard_rand,
      mx: standard_rand,
      my: standard_rand,
      mz: standard_rand,
      ax: standard_rand,
      ay: standard_rand,
      az: standard_rand,
      batv: standard_rand,
      batw: "true",
      dipw: "false",
      gravw: "false",
      gv0: standard_rand,
      gv1: standard_rand,
      gv2: standard_rand,
      gv3: standard_rand,
      gv4: standard_rand,
      gv5: standard_rand,
      gv6: standard_rand,
      gv7: standard_rand,
      magw: "true",
      dl_enabled: "true",
      tempw: "false",
      sync_marker: "Received",
      survey_sequence: rand(300) / 10,
      logging_sequence: rand(300) / 10,
      confidence_level: rand(300) / 10,
      average_quality: (rand(400) / 3.0).to_s,
      pump_pressure: 1300 + rand(5000) / 100.0,
      bore_pressure: rand(5000) / 100.0,
      annular_pressure: rand(5000) / 100.0,
      pump_state: "on",
      low_pulse_threshold: 8,
      tfo: rand(50000) / 100,
      tf: @tf_data.select{|tf| tf[:order] == 0}.first[:value],
      table: table,
      tool_face_data: @tf_data,
      uid: "abcd1234"
    }

  end

  def tool_face_data
    4.downto(0).map do |order|
      {
        order: order,
        status: 1,
        value: rand(360)
      }
    end
  end

  def table_item(name, quality, quality_value)
    {
      time_stamp: Time.now.utc.to_i.to_s,
      name: name,
      value: standard_rand / 10.0,
      quality: quality,
      quality_value: quality_value
    }
  end

  def table
    [
      table_item("SuSq = 1", "GV2=", standard_rand / 10.0),
      table_item("SDep =", "Gamma=", rand(6000) / 100.0),
      table_item("SuSq = 1", "GV2=", standard_rand / 10.0)
    ]
  end

  def pulse_value
    (rand(4000) / 100.0) - 20
  end

  def compressed_pulse_data(count)
    time = Time.now.to_f
    {
      time_stamp: ((time - count) * 1000).to_i,
      sample_rate: 10,
      values: count.downto(1).map { pulse_value }
    }
  end

  def old_pulse_data
    time = Time.now.to_f
    3.downto(1).map do |offset|
      {
        time_stamp: ((time - offset) * 1000).to_i,
        value: pulse_value
      }
    end
  end
end
