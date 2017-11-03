require "test_helper"

class TemplatesControllerTest < ActionController::TestCase
  setup do
    @user = create :user
    @job = create :job
    @template = create :template, job: @job, user: @user
  end

  test 'can hit index' do
    @controller.stub(:current_user, @user) do
      get :index
      assert :success
      assert_not_nil assigns(:templates)
    end
  end

  test 'can hit index with user id' do
    user = create :user
    template = create :template, job: @job, user: user, name: "abc123"

    get :index, { user_id: user.id }

    templates = JSON.parse(response.body)
    assert_equal 1, templates.count
    assert_equal template.name, templates.first["name"]
  end

  test 'can hit new' do
    @controller.stub(:current_user, @user) do
      get :new
      assert :success
      assert_not_nil assigns(:template)
    end
  end

  test 'can hit create' do
    @controller.stub(:current_user, @user) do
      post :create, template: { name: "Test", job_id: 1 }
      assert :success
      assert_not_nil assigns(:template)
    end
  end

  test 'can hit edit' do
    @controller.stub(:current_user, @user) do
      get :edit, id: @template.id
      assert :success
      assert_not_nil assigns(:template)
    end
  end

  test 'can hit update' do
    @controller.stub(:current_user, @user) do
      before = @template.dup
      patch :update, id: @template.id, template: { name: "Moar test" }
      assert :success
      assert @template != before
    end
  end

  test 'can hit destroy' do
    @controller.stub(:current_user, @user) do
      delete :destroy, id: @template.id
      assert :success
      assert Template.count == 0
    end
  end

  test 'can hit clone' do
    @controller.stub(:current_user, @user) do
      post :clone, template_id: @template.id, template: { name: "Test" }
      assert :success
    end
  end

  test 'can hit import' do
    @controller.stub(:current_user, @user) do
      new_user = create :user
      post :import, template_id: @template.id
      assert :success
    end
  end

end
