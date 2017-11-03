class ReportTypeSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :documents

  def documents
    object.documents.active
  end
end
