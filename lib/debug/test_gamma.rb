require 'http'

class TestGamma
  include TestHelpers

  def initialize(job)
    @job = job
  end

  def publish_notify
    url = "http://localhost:3000/v730/gammas" if Rails.env.development?
    url ||= "http://tracker-wolf.herokuapp.com/v730/gammas" unless Rails.env.development?
    call_api(url, new_data)
  end

  def new_data
    max_depth = Gamma.max_depth(Run.fuzzy_find(@job, 1))
    {
      measured_depth: (max_depth.first.try(:measured_depth) || 0) + 10,
      count: rand(2000) / 10,
      job_number: @job.name,
      run_number: 1
    }
  end
end
