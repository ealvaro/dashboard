require "test_helper"

class SearchesHelperTest < ActionView::TestCase
  def test_job_lookup
    job = create(:job)

    assert_equal job, get_job(job.name)
  end
end
