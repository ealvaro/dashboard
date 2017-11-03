require "test_helper"

class V700::JobsControllerTest < ActionController::TestCase

  test "missing headers get 401" do
    get :check, check_json
    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = bad_token
      get :check
      assert_response 401
    end
  end

  test "should return the job if is exists" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job, name: 'OK-123456')
      get :check, check_json
      assert_equal job.id, JSON.parse(response.body)['job']['id']
    end
  end

  test "should return empty if the job does not exists" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      create(:job, name: 'OK-654321')
      get :check, check_json
      assert_equal nil, JSON.parse(response.body)['job']
    end
  end

  test "should return the run if is exists" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job, name: 'OK-123456')
      run = create(:run, number: '12', job: job)
      get :check, check_json
      assert_equal run.id, JSON.parse(response.body)['run']['id']
    end
  end

  test "should return empty if the run DNE" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job, name: 'OK-123456')
      run = create(:run, number: '3', job: job)
      get :check, check_json
      assert_equal nil, JSON.parse(response.body)['run']
    end
  end

  test "should return the well if is exists" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      well = create(:well, name: 'well 12')
      get :check, check_json
      assert_equal well.id, JSON.parse(response.body)['well']['id']
    end
  end

  test "should return empty if the well DNE" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      create(:well, name: 'well 1')
      get :check, check_json
      assert_equal nil, JSON.parse(response.body)['well']
    end
  end

  test "should return the rig if is exists" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      rig = create(:rig, name: 'rig 12')
      get :check, check_json
      assert_equal rig.id, JSON.parse(response.body)['rig']['id']
    end
  end

  test "should return empty if the rig DNE" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      create(:rig, name: 'rig 1')
      get :check, check_json
      assert_equal nil, JSON.parse(response.body)['rig']
    end
  end

  test "should return the client if is exists" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      client = create(:client, name: 'client 12')
      get :check, check_json
      assert_equal client.id, JSON.parse(response.body)['client']['id']
    end
  end

  test "should return empty if the client DNE" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      create(:client, name: 'client 1')
      get :check, check_json
      assert_equal nil, JSON.parse(response.body)['client']
    end
  end

  test "should return the well if the job is already associated with a well" do
    run = create(:run, well: create(:well))
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      get :check, {job_id: run.job.id}
      assert_equal run.job.well.id, JSON.parse(response.body)['well']['id']
    end
  end

  test "should return the rig if the job is already associated with a rig" do
    run = create(:run, rig: create(:rig))
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      get :check, {job_id: run.job.id}
      assert_equal run.job.rig.id, JSON.parse(response.body)['rig']['id']
    end
  end

  test "should return the client if the job is already associated with a client" do
    job = create(:job, client: create(:client))
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      get :check, {job_id: job.id}
      assert_equal job.client.id, JSON.parse(response.body)['client']['id']
    end
  end

  ### Create Endpoint
  test "should create the job if it doesn't exist" do
    Job.destroy_all
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {job: {number:"OK-123456"}}
      assert_equal 1, Job.count
    end
  end

  test "should create the client if it doesn't exist" do
    Client.destroy_all
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {client: {name:"Client Name"}}
      assert_equal 1, Client.count
    end
  end

  test "should not create a run if the job is not present" do
    Run.destroy_all
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {run: {number:1}}
      assert_equal 0, Run.count
    end
  end

  test "should create a run if the job number is present" do
    Job.destroy_all
    Run.destroy_all
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {run: {number:1}, job: {number: "profitable job"}}
      assert_equal 1, Job.count
      assert_equal 1, Run.count
    end
  end

  test "should create a run if the job id is present" do
    job = create :job
    Run.destroy_all
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {run: {number:1}, job: {id: job.id}}
      assert_equal 1, Run.count
    end
  end

  test "should create a client if the name is present" do
    Client.destroy_all
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {client: {name: "client 123"}}
      assert_equal 1, Client.count
    end
  end

  test "should not create a new client if the client id is present and exists" do
    Client.destroy_all
    client = create :client
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      assert_equal 1, Client.count
      post :create, {client: {id: client.id, name: "bad name"}}
      assert_equal 1, Client.count
    end
  end

  test "should not alter the jobs client if the client name specified is different" do
    Client.destroy_all
    Job.destroy_all
    job = create(:job, client: create(:client, name: 'good name'))
    bad_client = create(:client, name: 'bad name')
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {job:{name: job.name}, client: {name:'bad name'}}
      assert job.client_id != bad_client.id
    end
  end

  test "should accurately associate the job and client" do
    Client.destroy_all
    Job.destroy_all
    job = create(:job, name: 'good job')
    job.client_id = nil
    job.save!
    client = create(:client, name: 'good client')
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {job:{number: job.name}, client: {name: client.name}}
      assert_equal job.reload.client, client
    end
  end

  test "should include all of the attributes" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      post :create, {job: {number: 'OK-123456'}, run:{number: 1}, well:{name:'well1'}, rig:{name:'rig1'}, client:{name: 'client1'}}
      result = JSON.parse(response.body)
      %w(job run well rig client).each do |key|
        assert !result[key].blank?
      end
    end
  end

  test "if the job has a different client than specified already" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job, client: create(:client))
      client_id = job.client_id
      client = create(:client, name: "bad client")
      post :create, {job:{id:job.id}, client:{name: client.name}}
      assert JSON.parse(response.body)["client"]["id"] == client_id
    end
  end

  test "if the job has a different rig than specified already" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      run = create(:run, rig: create(:rig))
      rig_id = run.rig.id
      rig = create(:rig, name: "rig name")
      post :create, {job:{id:run.job.id}, rig:{name: rig.name}}
      assert JSON.parse(response.body)["rig"]["id"] == rig_id
    end
  end

  test "if the job has a different well than specified already" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      run = create(:run, well: create(:well))
      well_id = run.well.id
      well = create(:well, name: "well name")
      post :create, {job:{id:run.job.id}, well:{name: well.name}}
      assert JSON.parse(response.body)["well"]["id"] == well_id
    end
  end

  test "well name should be present in the JSON" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      run = create(:run, well: create(:well))
      post :create, {job:{id:run.job.id}, well:{name: run.well.name}}
      assert JSON.parse(response.body)["well"]["name"] == run.well.name
    end
  end

  test "rig name should be present in the JSON" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      run = create(:run, rig: create(:rig))
      post :create, {job:{id:run.job.id}, rig:{name: run.rig.name}}
      assert JSON.parse(response.body)["rig"]["name"] == run.rig.name
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end

  def check_json
    {
      job_number: 'OK-123456 ',
      run_number: 12,
      well_name: 'well 12 ',
      rig_name: 'rig 12 ',
      client_name: 'client 12 '
    }
  end
end

