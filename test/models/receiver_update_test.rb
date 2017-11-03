require "test_helper"

class ReceiverUpdateTest < ActiveSupport::TestCase
  test 'receiver update factory should work' do
    assert_difference 'Update.count' do
      FactoryGirl.create(:receiver_update)
    end
  end

  test 'creating an update without a job should not raise an error' do
    assert_nothing_raised do
      ReceiverUpdate.create(job_number: "OK-123456")
    end
  end

  def create_with_job(type)
    update = create(type)
    update.job = Job.fuzzy_find(update.job_number)
    update.job ||= create(:job, name: update.job_number)
    update.save

    update
  end

  test 'should not add older receiver update' do
    create_with_job(:old_receiver_update)
    invalid = create(:invalid_receiver_update)

    refute_equal invalid.job.last_update_for_type(invalid.type), invalid
  end

  test 'should add newer receiver update' do
    create_with_job(:old_receiver_update)
    valid = create(:valid_receiver_update)

    assert_equal valid.job.last_update_for_type(valid.type), valid
  end

  test 'should associate job given job_number' do
    job = create :job
    update = FactoryGirl.create(:btr_receiver_update, job_number: job.name.downcase)
    assert_equal update.job, job
  end

  test 'should associate rig given rig_name' do
    rig = create :rig
    update = FactoryGirl.create(:btr_receiver_update, rig_name: rig.name.downcase)
    assert_equal update.rig, rig
  end

  test 'can get most recent update for job of correct type' do
    job = create :job
    update = create :leam_receiver_update, job_number: job.name, time: 1.minute.ago
    create :logger_update, job_number: job.name, time: 5.minutes.ago
    create :btr_receiver_update, job_number: job.name, time: Time.now
    create :btr_control_update, job_number: job.name, time: Time.now
    create :leam_receiver_update, job_number: job.name, time: 10.minutes.ago
    assert_equal update, LeamReceiverUpdate.last_update_for_job(job.name)
  end

  test 'properly adds to jobs recent update cache' do
    job = create :job
    update = create :btr_receiver_update, job_number: job.name
    assert_equal update.job.last_update_for_type(update.type), update
  end

  test 'can get last updates' do
    job = create :job
    bad_update = create :btr_receiver_update, job_number: job.name
    update = create :btr_receiver_update, job_number: job.name
    hash = Update.last_updates["BtrReceiverUpdate"]
    array = Update.last_updates(array: true)
    assert_equal hash, array
    assert array.include?(update.id)
  end

  test 'can delete older updates that aren\'t last for job' do
    job = create :job
    delete_update = create :btr_receiver_update, job_number: job.name, updated_at: 8.days.ago
    update = create :btr_receiver_update, job_number: job.name, updated_at: 8.days.ago
    last_updates = Update.last_updates(array: true)
    assert last_updates.include?(update.id)
    assert_not last_updates.include?(delete_update.id)
  end

  test 'can remove old updates' do
    job = create :job
    3.times { create :btr_receiver_update, job_number: job.name, created_at: 8.days.ago }

    assert_difference('Update.count', -2) { Update.destroy_old }
  end

  test 'keeps old update with associated notification' do
    job = create :job
    update = create :btr_receiver_update, job_number: job.name, created_at: 8.days.ago
    create :notification, notifiable: update

    2.times { create :btr_receiver_update, job_number: job.name, created_at: 8.days.ago }

    assert_difference('Update.count', -1) { Update.destroy_old }
  end

  test 'handles nil recent_updates cache' do
    job = create :job
    job.cache_will_change!
    job.cache["recent_updates"]["BtrReceiverUpdate"] = nil
    job.save

    assert_nothing_raised do
      Update.last_updates(array: true)
    end
  end

  test 'should merge tool face data' do
    data = {"value"=>10, "order"=>1, "status"=>1}
    update = create(:leam_receiver_update, tool_face_data: [data])

    update.merge_tool_face_data!([{"value"=>10, "order"=>2, "status"=>1}])

    assert_equal 2, update.tool_face_data.length
  end

  test 'should replace tool face data by order' do
    data = {"value"=>10, "order"=>1, "status"=>1}
    update = create(:leam_receiver_update, tool_face_data: [data])

    update.merge_tool_face_data!([{"value"=>100, "order"=>1, "status"=>1}])

    assert_equal 1, update.tool_face_data.length
    assert_equal 100, update.tool_face_data.first["value"]
  end

  test 'sample rate defaults to 10 when zero' do
    update = create(:leam_receiver_update)

    update.save_as_compressed([0, 1], 0, "1441256822062")

    assert_equal 10, update.pulse_data["sample_rate"]
  end

  test 'sample rate defaults to 153 when zero for APS EM' do
    update = create(:em_receiver_update)

    update.save_as_compressed([0, 1], 0, "1441256822062")

    assert_equal 153, update.pulse_data["sample_rate"]
  end

  test 'will cache pump_time after save' do
    tool = create :tool
    time = 1000
    update = create :leam_receiver_update, uid: tool.uid, pump_total_time: time
    assert_equal time, Tool.last.total_service_time
  end
end
