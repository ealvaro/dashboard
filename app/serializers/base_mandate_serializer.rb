class BaseMandateSerializer < ActiveModel::Serializer
  attributes  :token, :occurences, :priority, :tool_ids, :expiration,
              :tool_type_id, :tool_type_name, :contexts, :optional, :regions, :name

  def regions
    object.persisted? ? object.regions.map{|r| Region.find( r ).name } : []
  end

  def token
    object.public_token
  end

  def tool_ids
    object.for_tool_ids
  end

  def tool_type_id
    tool_type.id
  end

  def tool_type_name
    tool_type.name
  end

  def expiration
    object.expiration.utc.to_i if object.expiration
  end

  def region_name
    object.region.name if object.region
  end

  def contexts
    object.contexts.select(&:present?)
  end

  def tool_type
    @tool_type ||= ToolType.for_mandate(object.tool_type_klass)
  end

  def versionize(hash)
    Hash[hash.map{|k,v| [(k.to_s + "_v" + object.version).to_sym, v]}]
  end
end
