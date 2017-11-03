FactoryGirl.define do
  factory :receiver_update do
    team_viewer_id "123456789"
    team_viewer_password "123456789"
    job_number "OK-123456"
  end

  factory :leam_receiver_update, parent: :receiver_update, class: LeamReceiverUpdate do
    time Time.now
  end

  factory :btr_receiver_update, parent: :receiver_update, class: BtrReceiverUpdate do
    time Time.now
  end

  factory :em_receiver_update, parent: :receiver_update, class: EmReceiverUpdate do
    time Time.now
  end

  factory :btr_control_update, parent: :receiver_update, class: BtrControlUpdate do
    time Time.now
  end

  factory :old_receiver_update, parent: :receiver_update, class: BtrReceiverUpdate do
    job_number "rc-123456"
    time 5.minutes.ago
  end

  factory :invalid_receiver_update, parent: :old_receiver_update, class: BtrReceiverUpdate do
    time 10.minutes.ago
  end

  factory :valid_receiver_update, parent: :old_receiver_update, class: BtrReceiverUpdate do
    time Time.now
  end

  factory :proto_logger_update do
    team_viewer_id "123456789"
    team_viewer_password "123456789"
    job_number "OK-123456"
  end

  factory :logger_update, parent: :proto_logger_update, class: LoggerUpdate do
    time Time.now
  end

  factory :old_logger_update, parent: :proto_logger_update, class: LoggerUpdate do
    job_number "lg-123456"
    time 5.minutes.ago
  end

  factory :invalid_logger_update, parent: :old_logger_update, class: LoggerUpdate do
    time 10.minutes.ago
  end

  factory :valid_logger_update, parent: :old_logger_update, class: LoggerUpdate do
    time Time.now
  end

  factory :blank_sync_receiver_update, parent: :receiver_update, class: BtrReceiverUpdate do
    sync_marker ""
  end

end
