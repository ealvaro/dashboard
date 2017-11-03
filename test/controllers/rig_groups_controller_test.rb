require "test_helper"

class RigGroupsControllerTest < ActionController::TestCase

  def setup
    @rig ||= Rig.create(:name => 'Test Rig')
    @rig_group ||= RigGroup.create(:name => 'Test Group', :rig_ids => [@rig.id])
  end

  def test_index
    get :index
    assert_response 200
    assert_not_nil assigns(:rig_groups)
  end

  def test_new
    get :new
    assert_response :success
    assert_template :new
  end

  def test_create
    assert_difference('RigGroup.count') do
      post :create, rig_group: { name: 'Test Group', rig_ids: []}
    end

    assert_redirected_to notifiers_path
  end

  def test_edit
    get :edit, id: @rig_group
    assert_response :success
    assert_template :edit
  end

  def test_update
    put :update, id: @rig_group.id, rig_group: {:name => 'Other Test', :rig_ids => [@rig.id] }
    assert_response :success
  end

  def test_destroy
    assert_difference('RigGroup.count', -1) do
      delete :destroy, id: @rig_group
    end

    assert_response 200
  end

  def test_rigs
    get :rigs, id: @rig_group
    assert_response :success
    assert_equal "[{\"id\":#{@rig.id},\"name\":\"Test Rig\"}]", @response.body
  end

end
