class ToolTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  def id
    object.number
  end
end
