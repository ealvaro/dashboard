class SoftwareSerializer < ActiveModel::Serializer
  attributes :name, :version, :summary, :url, :uploaded_at

  def url
    object.binary.url
  end

  def uploaded_at
    object.updated_at.utc.to_i
  end

end
