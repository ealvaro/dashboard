require "test_helper"

class Push::ReportTypesControllerTest < ActionController::TestCase

  test "should only include active report types" do
    wrap_call do
      create(:report_type, active: true)
      create(:report_type, active: true)
      create(:report_type, active: false)
      get :index, {}
      res = get_response_json
      assert_equal 2, res.length
    end
  end

  test "should only include documents" do
    wrap_call do
      rt = create(:report_type, active: true)
      create(:document, report_type: rt, active: true)
      create(:document, report_type: rt, active: true)
      create(:document, report_type: rt, active: false)
      get :index, {}
      res = get_response_json
      assert_equal 2, res.first["documents"].length
    end
  end

  def good_token
    "teh-good-token"
  end

  def get_response_json
    JSON.parse(response.body)
  end

  private

  def wrap_call
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      yield
    end
  end
end
