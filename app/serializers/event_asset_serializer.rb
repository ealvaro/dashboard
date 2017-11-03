class EventAssetSerializer < ActiveModel::Serializer
  attributes :id, :file, :name, :url

  def url
    Rails.env.production? ? object.file.url : object.file.path
  end

end
