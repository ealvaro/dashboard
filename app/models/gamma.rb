class Gamma < ActiveRecord::Base
  belongs_to :run

  has_one :job, through: :run

  validate :unique_measured_depth_for_run

  scope :edited, -> {where("count != edited_count")}
  scope :by_job_id, ->(job_id) { where("jobs.id = ?", job_id).includes(:job).references(:job) }
  scope :max_depth, ->(run_id) { where("run_id = ?", run_id).order("measured_depth DESC").limit(1) }
  scope :by_fuzzy_measured_depth, ->(measured_depth) { where("ROUND(?, 6) = ROUND(measured_depth::numeric, 6)", measured_depth)}

  private
  def unique_measured_depth_for_run
      gamma = Gamma.where(run_id: run_id).by_fuzzy_measured_depth(measured_depth).first
      if gamma.present? && (id.nil? || gamma.id != id)
        errors.add(:measured_depth,
                   "Gamma #{gamma.id} already has this measured depth")
      end
    end
end
