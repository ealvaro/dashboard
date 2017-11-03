require "test_helper"

class LoggerUpdateTest < ActiveSupport::TestCase
  test 'logger update factory should work' do
    assert_difference 'Update.count' do
      FactoryGirl.create(:logger_update)
    end
  end

  test 'creating an update without a job should not raise an error' do
    assert_nothing_raised do
      LoggerUpdate.create(job_number: "OK-123456")
    end
  end

  def create_with_job(type)
    update = create(type)
    update.job = Job.fuzzy_find(update.job_number)
    update.job ||= create(:job, name: update.job_number)
    update.save

    update
  end

  test 'should not add older logger update' do
    create_with_job(:old_logger_update)
    invalid = create(:invalid_logger_update)

    refute_equal invalid.job.last_update_for_type(invalid.type), invalid
  end

  test 'should add newer logger update' do
    create_with_job(:old_logger_update)
    valid = create(:valid_logger_update)

    assert_equal valid.job.last_update_for_type(valid.type), valid
  end

  test 'should associate job given job_number' do
    job = create :job
    update = FactoryGirl.create(:logger_update, job_number: job.name.downcase)
    assert_equal update.job, job
  end

  test 'should associate rig given rig_name' do
    rig = create :rig
    update = FactoryGirl.create(:logger_update, rig_name: rig.name.downcase)
    assert_equal update.rig, rig
  end

  test 'can get most recent update for job of correct type' do
    job = create :job
    update = create :logger_update, job_number: job.name, time: 1.minute.ago
    create :logger_update, job_number: job.name, time: 5.minutes.ago
    create :btr_receiver_update, job_number: job.name, time: Time.now
    create :leam_receiver_update, job_number: job.name
    assert_equal update, LoggerUpdate.last_update_for_job(job.name)
  end

  test 'automatically adds to jobs recent update cache' do
    job = create :job
    update = create :logger_update, job_number: job.name
    assert_equal update.job.last_update_for_type(update.type), update
  end

  test 'can get last updates' do
    job = create :job
    bad_update = create :logger_update, job_number: job.name
    update = create :logger_update, job_number: job.name
    hash = Update.last_updates["LoggerUpdate"]
    array = Update.last_updates(array: true)
    assert_equal hash, array
    assert array.include?(update.id)
  end

  test 'can delete older updates that aren\'t last for job' do
    job = create :job
    delete_update = create :logger_update, job_number: job.name, updated_at: 8.days.ago
    update = create :logger_update, job_number: job.name, updated_at: 8.days.ago
    last_updates = Update.last_updates(array: true)
    assert last_updates.include?(update.id)
    assert_not last_updates.include?(delete_update.id)
  end
end
