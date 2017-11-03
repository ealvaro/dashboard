class GammaSerializer < ActiveModel::Serializer
  attributes :id, :job_number, :job_id, :measured_depth
  attributes :run_number, :run_id, :count, :edited_count
  attributes :created_at, :updated_at

  def job_number
    object.job.name
  end

  def job_id
    object.job.id
  end

  def run_number
    object.run.number
  end

  def run_id
    object.run.id
  end
end
