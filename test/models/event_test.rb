require "test_helper"

class EventTest < ActiveSupport::TestCase
  def event_hash
    {
      client_name: "Apache",
      job_number: "OK-1234",
      run_number: 1,
      tool: create( :tool ),
      event_type: "Configuration - Connection",
      time: DateTime.now,
      board_serial_number: "1234",
      board_firmware_version: "5432",
      reporter_type: 0
    }
  end

  def before_setup
    super
    User.last.update_attributes roles: Role.all
  end

  test "required fields are required" do
    %i(event_type tool time reporter_type).each do |field|
      e = Event.new
      e.valid?
      assert_equal true, e.errors[field].any?, "#{field} should have been required"
    end
  end

  test "notify should send if a crossover tag is present" do
    ce = create( :event, tags: { "crossover" => true } )
    assert ce.tags["crossover"]
    ce.notify!
    assert ActionMailer::Base.deliveries.first
  end

  test "notify should not send if a crossover tag is not present" do
    ActionMailer::Base.deliveries = []
    event = create( :event )
    assert event.tags.nil?
    event.notify!
    assert !ActionMailer::Base.deliveries.first
  end

  test "should create a client, job and run if they don't already exist" do
    client_count = Client.count
    job_count = Job.count
    run_count = Run.count
    event = Event.create!( event_hash )
    event
    assert_equal Client.count, client_count + 1
    assert_equal Job.count, job_count + 1
    assert_equal Run.count, run_count + 1
  end

  test "should setup the new client correctly" do
    Event.create!( event_hash.merge!( client_name: "EM" ) )
    assert_equal( "EM", Client.last.name )
  end

  test "client name should be case insensitive" do
    create(:client, name: "em")
    count = Client.count
    Event.create!( event_hash.merge!( client_name: "EM" ) )
    assert_equal count, Client.count
  end

  test "client name should ignore spaces" do
    Event.create!( event_hash.merge!( client_name: "    em    " ) )
    count = Client.count
    Event.create!( event_hash.merge!( client_name: "    EM    " ) )
    assert_equal count, Client.count
  end

  test "job name should be case insensitive" do
    create(:job, name: "ok-3243")
    count = Job.count
    Event.create!( event_hash.merge!( job_number: "OK-3243" ) )
    assert_equal count, Job.count
  end

  test "job name should ignore leading and trailing whitespace" do
    Event.create!( event_hash.merge!( job_number: "      ok-3243" ) )
    count = Job.count
    Event.create!( event_hash.merge!( job_number: "Ok-3243          " ) )
    assert_equal count, Job.count
  end

  test "should setup the new job name correctly" do
    Event.create!( event_hash.merge!( job_number: "OK-5678" ) )
    assert_equal( "OK-5678", Job.last.name )
  end

  test "should setup the new rig name correctly" do
    Event.create!( event_hash.merge!( rig_name: "rig name 123321" ) )
    assert_equal( "rig name 123321", Rig.last.name )
  end

  test "should associate with a previously existing rig" do
    rig = Rig.create( name: "rig name 123321" )
    Event.create!( event_hash.merge!( rig_name: "rig name 123321" ) )
    assert_equal( rig.id, Rig.last.id )
  end

  test 'should apply the correct run number' do
    Event.create!( event_hash.merge!( run_number: "123" ) )
    assert_equal( 123, Run.last.number )
  end

  test 'should only need the job and run numbers when the job exists' do
    job = create( :job, name: "bad name" )
    event = Event.create!( event_hash.delete_if{|k,v| k == "client_name" }.merge( job_number: "bad name" ) ).reload
    event
    event.reload
    assert_equal( job.client.name, event.run.job.client.name )
  end

  test 'should only need the job and run numbers when the job exists and the run exists' do
    job = create( :job, name: event_hash[:job_number] )
    job.runs.create( number: event_hash[:run_number] )
    event = Event.create!( event_hash.delete_if{|k,v| k == :client_name } )
    event
    assert_equal( job.client.name, event.run.job.client.name )
  end

  test 'should match not match runs when the run numbers are the same but the job number differs' do
    job = create(:job, name: "job1")
    run = create(:run, number: 1, job: job)
    job2 = create(:job, name: "job2")
    run2 = create(:run, number: 1, job: job2)

    event = Event.create( event_hash.merge( job_number: "job2", run_number: 1 ) )

    assert_equal run2, event.run
  end

  test 'if a user passes in a different client name for an existing job, the client name should be ignored' do
    job = create( :job, name: event_hash[:job_number] )
    job.runs.create( number: event_hash[:run_number] )
    event = Event.create( event_hash.merge( client_name: "Does not exist" ) )
    assert_equal( job.client.name, event.run.job.client.name )
  end
end
