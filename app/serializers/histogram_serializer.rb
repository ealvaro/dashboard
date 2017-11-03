class HistogramSerializer < ActiveModel::Serializer
  attributes :id, :name, :tool_ids, :job_number, :run_number, :service_number,
             :data

  def job_number
    object.job_number
  end

  def run_number
    object.run_number
  end
end