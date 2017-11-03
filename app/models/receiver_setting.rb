class ReceiverSetting < ActiveRecord::Base
  belongs_to :job

  before_create do
    last_key = ReceiverSetting.maximum(:key) || 0
    self.key ||= last_key + 1
  end

  scope :latest_versions, -> { order("version_number desc").group_by(&:key).map { |k, v| v.first } }
  scope :by_job, ->(job) { where("jobs.id = ?", job.id).includes(:job).references(:job) }

  def versions
    ReceiverSetting.where(key: self.key).order("version_number asc")
  end

  def versioned_dup
    version_number = versions.last.try(:version_number)
    if version_number.present?
      d = self.dup
      d.version_number = version_number + 1
      d
    else
      nil
    end
  end
end
