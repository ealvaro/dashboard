# encoding: utf-8

class ExportUploader < CarrierWave::Uploader::Base
  if Rails.env == 'production'
    storage( :fog )
  else
    storage( :file )
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(csv)
  end

end

