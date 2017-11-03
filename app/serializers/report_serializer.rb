class ReportSerializer < ActiveModel::Serializer
  attributes :id, :time, :event_type, :report_type

  has_many :event_assets, include: true

  def report_type
    object.report_type ? object.report_type.name : nil
  end
end