# encoding: utf-8

class AssetUploader < CarrierWave::Uploader::Base
  storage :fog

  self.fog_authenticated_url_expiration = 2.hours.seconds

  def store_dir
    uid = (model.uid.present? && model.uid) || model.event.tool.uid
    "uploads/tool_events/#{model.event.tool.tool_type.klass.underscore}/#{uid}"
  end

end
