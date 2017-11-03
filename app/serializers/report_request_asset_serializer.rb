class ReportRequestAssetSerializer < ActiveModel::Serializer
  attributes :id, :file, :name, :created_at, :url

  def url
    Rails.env.production? ? object.file.url : object.file.path
  end

end
