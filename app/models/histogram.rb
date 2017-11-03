class Histogram < ActiveRecord::Base
  has_and_belongs_to_many :tools
  belongs_to :job
  belongs_to :run
  validates :name, :job, :run, :service_number, :data, presence: true

  def job_number
    self.try(:job).try(:name).try(:upcase)
  end

  def run_number
    self.try(:run).try(:number)
  end
end