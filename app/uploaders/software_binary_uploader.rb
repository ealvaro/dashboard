# encoding: utf-8

class SoftwareBinaryUploader < CarrierWave::Uploader::Base
  storage :fog

  self.fog_authenticated_url_expiration = 2.hours.seconds

  def store_dir
    "uploads/software"
  end

end
