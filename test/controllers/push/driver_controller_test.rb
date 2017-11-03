require "test_helper"

class Push::DriverControllerTest < ActionController::TestCase
  test "should get mandates" do
    get :mandates
    assert_response :success
  end

  test "invalid format fets a 422" do
    params = {driver: {
      mandate_token: "the-token",
      timestamp_utc: Time.now.utc.to_i,
      tool_serial: "the-serial",
    }}
    post :receipts, params.merge(format: 'json')
    assert_response 422, "params used a 'driver' root"
  end

  test "post multiple receipts at once" do
    receipt_count = Receipt.count
    receipts = {"receipts"=>[
      {"mandate_token"=> "1a948428","timestamp_utc"=> 1390879239,"tool_serial"=> "abdcef"},
      {"mandate_token"=> "ba948428","timestamp_utc"=> 1390879239,"tool_serial"=> "abdcef"}
    ]}
    post :receipts, receipts.merge(format: 'json')
    assert_response :success
    assert_equal (receipt_count+2), Receipt.count
  end
end
