require "test_helper"

class V744::ReceiverSettingsControllerTest < ActionController::TestCase
  test 'can create settings' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create

      assert_response :success
    end
  end

  test 'can create correct type' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge("type": "BtrSlaveSetting")

      assert 1, BtrSlaveSetting.count
    end
  end

  test 'should assign job' do
    job = create(:job)

    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json.merge("job_number": job.name)

      setting = ReceiverSetting.find JSON.parse(response.body)["id"]
      assert setting.job.present?, "No job present"
    end
  end

  test 'can get index for all jobs' do
    create(:btr_setting)
    create(:lrx_slave_setting)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index

      assert_equal 2, JSON.parse(response.body).count
    end
  end

  test 'can filter index by type' do
    create(:btr_setting)
    create(:lrx_slave_setting)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index, type: "BtrSetting"

      assert_equal 1, JSON.parse(response.body).count
    end
  end

  test 'can filter index by job' do
    create(:btr_slave_setting)
    create(:btr_slave_setting)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index, job_number: Job.last.name

      assert_equal 1, JSON.parse(response.body).count
    end
  end

  test 'can filter index by type and job' do
    jobA = create(:job)
    jobB = create(:job)
    create(:btr_slave_setting, job: jobA)
    create(:btr_slave_setting, job: jobB)
    create(:lrx_slave_setting, job: jobA)
    create(:lrx_slave_setting, job: jobB)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index, type: "BtrSlaveSetting", job_number: Job.last.name

      assert_equal 1, JSON.parse(response.body).count
    end
  end

  test 'index should have the latest revision' do
    v1 = create(:btr_setting)
    v2 = v1.versioned_dup
    v2.rxdt = 9000
    v2.save

    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index

      assert_equal 1, JSON.parse(response.body).count
      assert_equal v2.rxdt, JSON.parse(response.body).first["rxdt"]
    end
  end

  test 'index should have the latest revisions' do
    av1 = create(:btr_setting)
    av2 = av1.versioned_dup
    av2.rxdt = 9000
    av2.save

    bv1 = create(:btr_setting)
    bv2 = bv1.versioned_dup
    bv2.rxdt = 9000
    bv2.save

    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index

      assert_equal 2, JSON.parse(response.body).count
      assert_equal 9000, JSON.parse(response.body).first["rxdt"]
      assert_equal 9000, JSON.parse(response.body).last["rxdt"]
    end
  end

  test 'can filter index by type and job with latest revision' do
    jobA = create(:job)
    jobB = create(:job)
    create(:btr_slave_setting, job: jobA)
    create(:btr_slave_setting, job: jobB)
    create(:lrx_slave_setting, job: jobA)
    v1 = create(:lrx_slave_setting, job: jobB)
    v2 = v1.versioned_dup
    v2.rxdt = 9000
    v2.save

    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index, type: v2.type, job_number: v2.job.name

      assert_equal 1, JSON.parse(response.body).count
      assert_equal v2.rxdt, JSON.parse(response.body).first["rxdt"]
    end
  end

  test 'index returns keys as ids' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      setting = create(:btr_setting, key: -12)

      get :index

      assert_equal setting.key, JSON.parse(response.body).first["id"]
    end
  end

  test 'update should create new versioned setting' do
    setting = create(:btr_setting)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do

      assert_difference('ReceiverSetting.count') do
        put :update, id: setting.key, evim: "changed"
      end
    end
  end

  test 'can update a value' do
    setting = create(:btr_setting, evim: "original")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      put :update, id: setting.key, evim: "updated!"

      assert_response :success
      assert_equal "updated!", setting.versions.last["evim"]
    end
  end

  test 'can re-update a value' do
    setting = create(:btr_setting, evim: "original")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      put :update, id: setting.key, evim: "update1"
      put :update, id: setting.key, evim: "update2"

      assert_equal "update2", setting.versions.last["evim"]
    end
  end

  test 'uses last version to update a value' do
    setting = create(:btr_setting, evim: "original")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      put :update, id: setting.key, evim: "update1", rxdt: 2
      put :update, id: setting.key, evim: "update2"

      assert_equal 2, setting.versions.last["rxdt"]
    end
  end

  test 'update with bad key should return failure' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      put :update, id: -1, evim: "bad id"

      assert_response :bad_request
    end
  end

  test 'can update array pwin' do
    setting = create(:btr_setting, pwin: [1.0])
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      put :update, id: setting.key, pwin: [1.0, 2.0]

      assert_equal 2, setting.versions.last["pwin"].length
    end
  end

  def json
    @json ||= ActiveSupport::JSON.decode( File.read("#{Rails.root}/test/fixtures/receiver_settings.json"))
  end

  def good_token
    "teh-good-token"
  end
end
