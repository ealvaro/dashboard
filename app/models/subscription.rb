class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :job
  belongs_to :run
  belongs_to :threshold_setting

  serialize :interests, Array

  validates :job_id, presence: true, unless: :run
  validates :job_id, absence: {message: "Job must be blank when a Run is present"}, if: :run
  validates :run_id, presence: true, unless: :job
  validates :threshold_setting, presence: true, if: lambda {|obj| obj.interested?(ThresholdNotification)}
  validate :interests_only_klasses

  def interested?(klass)
    interests.include? klass.to_s
  end

  def job
    job_id.present? ? Job.find(job_id) : run.try(:job)
  end

  private
    def interests_only_klasses
      unless interests.empty? || interests.all?{|i| valid_klasses.include?(i)} && interests.all?{|i| i.is_a? String }
        errors.add(:interests, "contains invalid string representations of klasses.")
      end
    end

    def valid_klasses
      %w(
        RequestSurveyApproval
        RequestCorrection
        ThresholdNotification
        CorrectedNotification
        )
    end
end
