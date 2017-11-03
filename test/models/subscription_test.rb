require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  it 'should have a valid factory'do
    assert create(:subscription)
  end
  it 'should restrict the values of interests' do
    exception = assert_raises(ActiveRecord::RecordInvalid) {create(:subscription, interests: [RequestCorrection])}
    assert exception.message =~ /string/
  end

  it 'should restrict the values of interests' do
    exception = assert_raises(ActiveRecord::RecordInvalid) {create(:subscription, interests: ["Alert"])}
    assert exception.message =~ /klass/
  end

  it 'should not allow a job_id if a run is present' do
    exception = assert_raises(ActiveRecord::RecordInvalid) {create(:subscription, job: create(:job), run: create(:run))}
    assert exception.message =~ /Run is present/
  end
end
