module ReceiverUpdatesControllerTestHelper
  def fixture_path
    "#{Rails.root}/test/fixtures/active_jobs/"
  end

  def decode_json_file(file)
    json = File.read(file)
    ActiveSupport::JSON.decode(json).merge(time_stamp: DateTime.now.utc)
  end

  def json
    @json ||= decode_json_file(fixture_path + "receiver.json")
  end

  def minimal_json
    @minimal_json ||= decode_json_file(fixture_path + "receiver_min.json")
  end

  def good_token
    "teh-good-token"
  end
end
