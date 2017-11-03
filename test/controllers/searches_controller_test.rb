require "test_helper"

class SearchesControllerTest < ActionController::TestCase
  setup do
    @user = User.create! name: 'Test',
                        email: 'test@gmail.com',
                        password: 'password1',
                        password_confirmation: 'password1'
    @tool_type = ToolType.create! description: "iamatooltype"
    @tool = @tool_type.tools.create! uid: "a1b2c3d4"
    @job = Job.create! name: "ABC-1234"
    @run = Run.create! job: @job,
                       number: 123456
    @report_type = ReportType.create name: 'iamareporttype'
    @event = Event.create! event_type: "Configuration - Connection",
                          tool: @tool,
                          time: Time.now,
                          report_type: @report_type,
                          reporter_type: '0',
                          run: @run,
                          job: @job,
                          job_number: @job.name
    @report_request = ReportRequest.create! job: @job,
                                            requested_by: @user
    @survey = Survey.create! run: @run,
                             measured_depth: 123,
                             key: "ec54ac3c78f4333f"
    @software_type = SoftwareType.create! name: 'Bunnies'
    @software = Software.create! software_type: @software_type, version: '1.1.1'
    @client = Client.create name: "Bob"
    @well = Well.create name: "iamawell"
    @formation = Formation.create name: "iamaformation"
  end

  test "should return tool" do
    results = Tool.search(@tool.uid)
    assert_equal @tool, results.first
  end

  test "should return event" do
    results = Event.search(@job.name)
    assert_equal @event, results.first
  end

  test "should return job" do
    results = Job.search(@job.name)
    assert_equal @job, results.first
  end

  test "should return report_request" do
    results = ReportRequest.search([@job])
    assert_equal @report_request, results.first
  end

  test "should return tool_type" do
    results = ToolType.search(@tool_type.description)
    assert_equal @tool_type, results.first
  end

  test "should return survey" do
    results = Survey.search([@job])
    assert_equal @survey, results.first
  end

  test "should return software" do
    results = Software.search(@software_type.name)
    assert_equal @software, results.first
  end

  test "should return run" do
    results = Run.search([@job])
    assert_equal @run, results.first
  end

  test "should return client" do
    results = Client.search(@client.name)
    assert_equal @client, results.first
  end
end
