class ShallowSubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :job_id, :run_id, :interests, :created_at, :updated_at, :errors, :threshold_setting_id
  attributes :job, :run

  has_one :threshold_setting

  def job
    object.job ? {id: object.job.id, name: object.job.name} : nil
  end

  def run
    object.run.present? ? {id: object.run.id, name: object.run.number} : nil
  end
end