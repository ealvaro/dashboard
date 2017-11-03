require "test_helper"

class UpdateNotifierTest < ActiveSupport::TestCase
  test 'should pretty format values' do
    configuration = UpdateNotifier.config_from_string("LeamReceiverUpdate mx < 1 or BtrReceiverUpdate sync_marker != Received")
    notifier = create(:update_notifier, configuration: configuration)

    assert_equal "LRx Mx is less than 1 or BTR Monitor Sync marker is not equal to Received",
                 notifier.pretty_configuration
  end

  test 'should pretty format pump time values' do
    configuration = UpdateNotifier.config_from_string("BtrControlUpdate pump_on_time > 9000 and LeamReceiverUpdate pump_off_time < 3781500")
    notifier = create(:update_notifier, configuration: configuration)

    assert_equal "BTR Control Pump on time is greater than 00:00:09 and LRx Pump off time is less than 01:03:01",
                 notifier.pretty_configuration
  end

  test 'should pretty format for contains' do
    configuration = UpdateNotifier.config_from_string("Logger rig_name include? Big")
    notifier = create(:update_notifier, configuration: configuration)

    assert_equal "Logger Rig name contains Big", notifier.pretty_configuration
  end

  test 'should pretty format complex alerts' do
    configuration = {"type"=>"grouping","boolean"=>"and","conditions"=>[{"type"=>"condition","placeholder"=>"value","update"=>"LeamReceiverUpdate","field"=>"ax","operator"=>"==","value"=>"1","selectValue"=>"","valueOp"=>"","conditions"=>[]},{"type"=>"grouping","boolean"=>"and","conditions"=>[{"type"=>"condition","placeholder"=>"value","update"=>"BtrReceiverUpdate","field"=>"ay","operator"=>">","value"=>"2","selectValue"=>"","valueOp"=>"","conditions"=>[]},{"type"=>"grouping","boolean"=>"or","conditions"=>[{"type"=>"condition","placeholder"=>"value","update"=>"LoggerUpdate","field"=>"azm","operator"=>"==","value"=>"3","selectValue"=>"","valueOp"=>"","conditions"=>[]},{"type"=>"condition","placeholder"=>"value","update"=>"LoggerUpdate","field"=>"inc","operator"=>">","value"=>"4","selectValue"=>"","valueOp"=>"","conditions"=>[]}]}]}]}
    notifier = create(:update_notifier, configuration: configuration)

    assert_equal "LRx Ax is equal to 1 and (BTR Monitor Ay is greater than 2 and (Logger Azm is equal to 3 or Logger Inc is greater than 4))",
                 notifier.pretty_configuration
  end

  test 'should pretty format pump time value in hours:minutes:seconds' do
   configuration = {"type"=>"grouping","boolean"=>"and","conditions"=>["type"=>"condition","update"=>"LeamReceiverUpdate","field"=>"pump_total_time","operator"=>">","value"=>'14644000',"textValue"=>'04:04:04']}
   notifier = create(:update_notifier, configuration: configuration)

   refute_match "14644000", notifier.pretty_configuration
   assert_match "04:04:04", notifier.pretty_configuration
 end

  test 'should return only visible notifiers' do
    create(:update_notifier)
    create(:update_notifier, hidden: true)

    assert_equal 1, UpdateNotifier.visible.count
  end

  test 'should return only associatied notifiers for type' do
    create(:global_notifier)
    create(:rig_notifier)

    assert_equal 1, GlobalNotifier.count
  end

  test 'should trigger on comma-separated numeric values' do
    value = UpdateNotifier.make_value("1,200", "", "mx")

    trigger = UpdateNotifier.test_trigger(1200, '==', value)

    assert_equal true, trigger
  end

  test 'should trigger on false field values' do
    value = UpdateNotifier.make_value("false", "", "dipw")

    trigger = UpdateNotifier.test_trigger(false, '==', value)

    assert_equal true, trigger
  end

  test 'should trigger with != operator' do
    value = UpdateNotifier.make_value("false", "", "dipw")

    trigger = UpdateNotifier.test_trigger(true, '!=', value)

    assert_equal true, trigger
  end

  test 'should render status' do
    update = create(:logger_update, gravity: 1.1)
    notifier = create(:update_notifier)

    status = notifier.humanize_status("gravity", update)

    assert_equal "Logger Gravity: 1.1", status
  end

  test 'should round numeric value on status' do
    update = create(:logger_update, gravity: 100.5555555)
    notifier = create(:update_notifier)

    status = notifier.humanize_status("gravity", update)

    assert_equal "Logger Gravity: 100.56", status
  end

  test 'should not round number-like value on status' do
    update = create(:leam_receiver_update, decode_percentage: 100)
    notifier = create(:update_notifier)

    status = notifier.humanize_status("decode_percentage", update)

    assert_equal "LRx Decode percentage: 100", status
  end

  test 'should render string value as is' do
    update = create(:leam_receiver_update, pump_state: "rockin")
    notifier = create(:update_notifier)

    status = notifier.humanize_status("pump_state", update)

    assert_equal "LRx Pump state: rockin", status
  end

  test 'should render status on meta field' do
    update = create(:logger_update, created_at: 1.minute.ago)
    configuration = UpdateNotifier.config_from_string("LoggerUpdate last_update > 1")
    notifier = create(:update_notifier, configuration: configuration)

    status = notifier.humanize_status("last_update", update)

    assert_match "Last update: #{update.created_at.to_formatted_s(:db)}", status
  end

  test 'empty string should show as blank' do
    update = create(:logger_update, sync_marker: "")
    configuration = UpdateNotifier.config_from_string("BtrReceiverUpdate sync_marker = blank")
    notifier = create(:update_notifier, configuration: configuration)

    status = notifier.humanize_status("sync_marker", update)

    assert_equal "Logger Sync marker: blank", status
  end

  def job
    @job || (@job = create(:job, name:"LA-012345"))
  end

  def logger_condition(condition)
    "LoggerUpdate #{condition}"
  end

  def config(condition)
    UpdateNotifier.config_from_string(condition)
  end

  def logger_config(condition)
    config(logger_condition(condition))
  end

  def logger_config2(boolean, cond1, cond2)
    config("#{logger_condition(cond1)} #{boolean} #{logger_condition(cond2)}")
  end

  test 'should trigger notification from simple notifier' do
    create(:logger_update, job_number: job.name, azm: 9000)
    create(:update_notifier, configuration: logger_config("azm > 1"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from temperature notifier in celcius' do
    create(:logger_update, job_number: job.name, temperature: 262)
    create(:update_notifier,
           configuration: logger_config("temperature < 200 C"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from true/false notifier' do
    create(:leam_receiver_update, job_number: job.name, dipw: false)
    create(:update_notifier,
           configuration: config("LeamReceiverUpdate dipw == false"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from on/off notifier' do
    create(:leam_receiver_update, job_number: job.name, pump_state: "on")
    create(:update_notifier,
           configuration: config("LeamReceiverUpdate pump_state == on"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from blank sync_marker notifier' do
    create(:leam_receiver_update, job_number: job.name, sync_marker: "")
    create(:update_notifier,
           configuration: config("LeamReceiverUpdate sync_marker == blank"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from Y/N notifier' do
    create(:logger_update, job_number: job.name, pumps_on: true)
    create(:update_notifier, configuration: logger_config("pumps_on == Y"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from number-like notifier' do
    create(:logger_update, job_number: job.name, survey_md: 14000)
    create(:update_notifier, configuration: logger_config("survey_md == 14000"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from client_name notifier' do
    create(:logger_update, job_number: job.name, client_name: "my-client")
    create(:update_notifier,
           configuration: logger_config("client_name == my-client"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from notifier with contains' do
    create(:logger_update, job_number: job.name)
    create(:update_notifier,
           configuration: logger_config("job_number include? LA"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification with contains case-insensitive' do
    create(:logger_update, job_number: job.name)
    create(:update_notifier,
           configuration: logger_config("job_number include? la"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from notifier with not contains' do
    create(:logger_update, job_number: job.name)
    create(:update_notifier,
           configuration: logger_config("job_number exclude? nope"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from type notifier' do
    create(:logger_update, job_number: job.name)
    create(:update_notifier,
           configuration: logger_config("type == LoggerUpdate"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification from last_update notifier' do
    create(:logger_update, job_number: job.name)
    create(:update_notifier, configuration: logger_config("last_update > 0"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  def create_2_condition_logger_update
    create(:logger_update, job_number: job.name,
           weight_on_bit: 9, temperature: 262)
  end

  def false_a
    "weight_on_bit == 1"
  end

  def true_a
    "weight_on_bit == 9"
  end

  def false_b
    "temperature > 200 C"
  end

  def true_b
    "temperature < 200 C"
  end

  test 'should not trigger notification with false OR false condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("or", false_a, false_b))

    assert_no_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification with true OR false condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("or", true_a, false_b))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification with false OR true condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("or", false_a, true_b))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification with true OR true condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("or", true_a, true_b))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should not trigger notification with false AND false condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("and", false_a, false_b))

    assert_no_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should not trigger notification with true AND false condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("and", true_a, false_b))

    assert_no_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should not trigger notification with false AND true condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("and", false_a, true_b))

    assert_no_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification with true AND true condition' do
    create_2_condition_logger_update
    create(:update_notifier,
           configuration: logger_config2("and", true_a, true_b))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should create only one notification when twice triggered' do
    create(:logger_update, job_number: job.name, inc: 9000)
    create(:update_notifier, configuration: logger_config("inc > 1"))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should create two notifications if one is completed' do
    create(:logger_update, job_number: job.name, inc: 9000)
    create(:update_notifier, configuration: logger_config("inc > 1"))

    assert_difference('Notification.count', 2) do
      UpdateNotifier.trigger_from_last_updates
      Notification.last.update_attributes completed_at: DateTime.now,
                                          completed_status: "Resolved"

      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should create two notifications when triggered with different jobs' do
    create(:update_notifier, configuration: logger_config("inc > 1"))

    assert_difference('Notification.count', 2) do
      create(:logger_update, job_number: job.name, inc: 9000)
      UpdateNotifier.trigger_from_last_updates

      job2 = create(:job, name:"OK-140500")
      create(:logger_update, job_number: job2.name, inc: 9000)
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should not trigger notification without all updates' do
    create(:leam_receiver_update, job_number: job.name, azm: 0)

    conditions = "LeamReceiverUpdate azm < .5 and BtrReceiverUpdate azm < 0.5"
    create(:update_notifier, configuration: config(conditions))

    assert_no_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification with all updates' do
    create(:leam_receiver_update, job_number: job.name, azm: 0)
    create(:btr_receiver_update, job_number: job.name, azm: 0)

    conditions = "LeamReceiverUpdate azm < .5 and BtrReceiverUpdate azm < 0.5"
    create(:update_notifier, configuration: config(conditions))

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should trigger notification on complex notifier' do
    create(:leam_receiver_update, job_number: job.name,
           gama: 20.6, az: 18, batw: true)
    create(:btr_receiver_update, job_number: job.name, ax: 13.735, ay: 18.254)
    configuration = ActiveSupport::JSON.decode(File.read("#{Rails.root}/test/fixtures/notifiers/configuration.json"))
    create(:update_notifier, configuration: configuration)

    assert_difference('Notification.count') do
      UpdateNotifier.trigger_from_last_updates
    end
  end

  test 'should provide complex notifier description from updates' do
    create(:leam_receiver_update, job_number: job.name,
           gama: 20.6, az: 18, batw: true)
    create(:btr_receiver_update, job_number: job.name, ax: 13.735)
    create(:btr_control_update, job_number: job.name, ay: 18.254)
    configuration = ActiveSupport::JSON.decode(File.read("#{Rails.root}/test/fixtures/notifiers/configuration.json"))
    create(:update_notifier, configuration: configuration)

    UpdateNotifier.trigger_from_last_updates

    assert_equal "LRx Gama: 20.6, BTR Monitor Ax: 13.74, BTR Control Ay: 18.25, LRx Az: 18.0, LRx Batw: true",
                 Notification.active.last.description
  end

  test 'should update notification with new update' do
    create(:update_notifier, configuration: logger_config("inc > 1"))
    create(:logger_update, job_number: job.name, inc: 2)
    UpdateNotifier.trigger_from_last_updates

    create(:logger_update, job_number: job.name, inc: 3,
           time: DateTime.now.utc + 2.minutes)
    UpdateNotifier.trigger_from_last_updates


    assert_equal "Logger Inc: 3.0", Notification.active.last.description
  end

  test 'can trigger user template notification' do
    user = create :user
    job = create :job
    template = create(:template, job: job, user: user)
    create(:template_notifier, notifierable: template, configuration: logger_config("inc > 1"))
    create(:logger_update, job_number: job.name, inc: 2)
    UpdateNotifier.trigger_from_last_updates

    assert_equal "Logger Inc: 2.0", Notification.active.last.description
  end
end
