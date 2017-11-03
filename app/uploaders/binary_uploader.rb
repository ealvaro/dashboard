# encoding: utf-8

class BinaryUploader < CarrierWave::Uploader::Base
  storage (Rails.env.test? && :file) || :fog

  self.fog_authenticated_url_expiration = 2.hours.seconds

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
