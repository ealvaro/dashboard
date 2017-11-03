require "test_helper"

class JobTest < ActiveSupport::TestCase
  test 'the factroy should create a valid job' do
    job = create( :job )
    assert( job.valid? )
  end

  test "destroying the job's client should destroy the job" do
    job = create( :job )
    job.client.destroy
    assert_equal( Job.count, 0 )
  end

  test 'destroying a job should destroy associated run records' do
    run = create( :run_record ).run
    assert_equal( Job.count, 1 )
    assert_equal( RunRecord.count, 1 )
    run.job.destroy
    assert_equal( Job.count, 0 )
    assert_equal( RunRecord.count, 0 )
  end

  test 'can correctly add to recent updates' do
    job = create :job
    update = create :logger_update, job_number: job.name
    job.add_to_recent_updates update
    assert_equal update, job.last_update_for_type(update.type)
  end

  test 'can only keep 5 most recent updates' do
    job = create :job
    updates = []
    create(:btr_receiver_update, job_number: job.name)
    create(:leam_receiver_update, job_number: job.name)

    6.times do
      updates << create(:logger_update, job_number: job.name)
    end

    updates.each do |update|
      job.add_to_recent_updates update
    end

    ids = updates.map &:id
    assert_equal ids[1..-1], job.recent_updates_for_type(updates.last.type).pluck(:id)
  end

  test 'can get updates_history' do
    job = create :job
    updates = []
    updates << btr = create(:btr_receiver_update, job_number: job.name)
    updates << leam = create(:leam_receiver_update, job_number: job.name)
    updates << logger = create(:logger_update, job_number: job.name)
    updates.each do |update|
      job.add_to_recent_updates update
    end
    assert job.updates_history["BtrReceiverUpdate"].include? btr
    assert job.updates_history["LeamReceiverUpdate"].include? leam
    assert job.updates_history["LoggerUpdate"].include? logger
  end

  test 'active scope will not get inactive jobs' do
    active_job = create :job
    inactive_job = create :job, inactive: true
    assert Job.active.include? active_job
    assert_not Job.active.include? inactive_job
  end
end
