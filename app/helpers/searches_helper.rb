module SearchesHelper
  def get_job(name)
    Job.find_by name: name
  end
end
