require "test_helper"

class V750::NotificationsControllerTest < ActionController::TestCase
  test "should return active notifications by default" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:notification)
      create(:notification)
      create(:notification, completed_at: DateTime.now, completed_status: 'Resolved')

      get :index

      assert_equal 2, JSON.parse(response.body).length
    end
  end

  test "should return all notifications when asked" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:notification)
      create(:notification)
      create(:notification, completed_at: DateTime.now, completed_status: 'Resolved')

      get :index, {all: true}

      assert_equal 3, JSON.parse(response.body).length
    end
  end

  test "should return completed notifications when asked" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:notification)
      create(:notification)
      create(:notification, completed_at: DateTime.now, completed_status: 'Resolved')

      get :index, {completed: true}

      assert_equal 1, JSON.parse(response.body).length
    end
  end

  test "should limit by job number when asked" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = create(:run)
      create(:notification, notifiable: logger_update(run))

      get :index, {job_number: run.job.name, all: true}

      assert_equal 1, JSON.parse(response.body).length
    end
  end

  test "should limit by active and job number when asked" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:notification)
      create(:notification, completed_at: DateTime.now, completed_status: 'Resolved')
      run = create(:run)
      create(:notification, notifiable: logger_update(run))
      create(:notification, notifiable: logger_update(run),
             completed_at: DateTime.now, completed_status: 'Resolved')

      get :index, {active: true, job_number: run.job.name}

      assert_equal 1, JSON.parse(response.body).length
    end
  end

  test "completing a notification successfully" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      user = create(:user)
      @controller.stub(:current_user, user) do
        notifier = create(:global_notifier)
        notification = create(:notification, notifier: notifier)

        put :complete, { notification_id: notification.id, status: 'Resolved' }

        assert_response :success
      end
    end
  end

  test "completing more than one notification successfully" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      user = create(:user)
      @controller.stub(:current_user, user) do
        notifier = create(:global_notifier)
        notification1 = create(:notification, notifier: notifier)
        notification2 = create(:notification, notifier: notifier)

        put :complete, { notification_ids: [notification1.id,notification2.id], status: 'Resolved' }

        assert_response :success
      end
    end
  end

  test "can hit search endpoint" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :search, params: { keyword: "Testing..." }
      assert_response 200
    end
  end

  def logger_update(run)
    LoggerUpdate.create!(job_number: run.job.name,
                         run_number: run.number,
                         time: 5.minutes.ago,
                         team_viewer_id: "1",
                         team_viewer_password: "2")
  end

  def good_token
    "good-token"
  end
end
