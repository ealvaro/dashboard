class DeepRunSerializer < RunSerializer
  attributes :reports

  has_many :events
  has_many :run_records

  def reports
    ActiveModel::ArraySerializer.new(object.events.where(event_type: 'Report - Upload'), each_serializer: ReportSerializer).as_json
  end
end
