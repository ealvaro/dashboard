class RunRecordSerializer < RunRecordShallowSerializer
  attributes :job, :job_show_url, :show_url
  has_one :tool
  has_one :run

  def job
    object.run.job
  end

  def job_show_url
    job_path(object.run.job)
  end

  def show_url
    run_record_path(object)
  end
end
