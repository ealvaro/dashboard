class RigGroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :rigs

  def rigs
    object.try :rigs
  end
end
