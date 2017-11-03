if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_KEY'],
      :region                 => 'us-west-2',
    }
    config.fog_directory  = ENV["AWS_BUCKET"]
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'Local',
      :local_root                   => Rails.root
    }
  end
end
