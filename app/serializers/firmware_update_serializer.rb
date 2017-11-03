class FirmwareUpdateSerializer < ActiveModel::Serializer
  attributes :tool_type, :version, :hardware_version, :contexts, :url, :uploaded_at, :regions, :for_serial_numbers, :last_edit_by

  def regions
    object.persisted? ? object.regions.map{|r| Region.find( r ).name } : []
  end
  def url
    object.binary.url
  end

  def uploaded_at
    object.updated_at.utc.to_i
  end

  def last_edit_by
    if object.last_edit_by
      object.last_edit_by.email
    end
  end

end
