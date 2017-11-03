class NotifierSerializer < ActiveModel::Serializer
  attributes :id, :name, :configuration, :display_configuration,
             :type, :display_type, :hidden

  def display_configuration
    object.pretty_configuration
  end
end
