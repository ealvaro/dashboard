require "test_helper"

class TemplateNotifiersControllerTest < ActionController::TestCase
  setup do
    admin = create(:user, roles: ['Admin'])
    session[:user_id] = admin.id
    job = create :job
    @template = create :template, job: job, user: admin
  end

  test "can get index" do
    get :index, template_id: @template.id
    assert_response 200
    assert_not_nil assigns(:notifiers)
  end

  test "can post create" do
    configuration = Notifier.config_from_string("a r + y")
    params = { name: 'orange',
               configuration: configuration,
               associated_data: { job_id: @template.job.id,
                                  template_id: @template.id } }
    assert_difference('TemplateNotifier.count') do
      post :create, notifier: params
    end
  end
end
