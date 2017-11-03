# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  if Rails.env == 'production'
    storage( :fog )
  else
    storage( :file )
  end

  def store_dir
    "uploads/run_records/#{model.id}/images"
  end

  def extension_white_list
    %w(jpg png jpeg)
  end
end

