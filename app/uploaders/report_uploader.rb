# encoding: utf-8

class ReportUploader < CarrierWave::Uploader::Base
  storage :fog

  self.fog_authenticated_url_expiration = 2.hours.seconds

  def store_dir
    "uploads/reports/#{model.report_request.job_number.gsub("-", "_").downcase}"
  end

end
