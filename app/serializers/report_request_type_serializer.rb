class ReportRequestTypeSerializer < ActiveModel::Serializer
  attributes :id, :type, :scale, :display_name, :created_at

  def scale
    object.scaling
  end

  def type
    object.name
  end

end
