class V730::ReportRequestSerializer < ActiveModel::Serializer
  attributes :id, :errors, :created_at, :updated_at, :report_request_type
  attributes :measured_depth, :inc, :azm, :job_id, :job_number, :job_url
  attributes :succeeded, :failed, :run_id, :description, :start_depth
  attributes :software_installation_id, :completed_by, :requested_by
  attributes :logviz_formats, :las_export, :end_depth

  has_many :report_request_assets, include: true

  def job_number
    object.job.name
  end

  def job_url
    job_path(object.job)
  end

  def requested_by
    if object.requested_by
      object.requested_by.email
    end
  end

  def succeeded
    object.succeeded?
  end

  def failed
    object.failed?
  end

  def logviz_formats
    ActiveModel::ArraySerializer.new(object.report_request_types,
                                     each_serializer: ReportRequestTypeSerializer)
  end

end
