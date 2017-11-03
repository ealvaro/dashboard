require 'type_conversion'

class ReportRequest < ActiveRecord::Base
  include Authority::Abilities
  include TypeConversion

  belongs_to :job
  belongs_to :run
  belongs_to :requested_by, class_name: "User"

  has_many :report_request_assets
  has_and_belongs_to_many :report_request_types

  scope :active, -> {where("failed_at is null and succeeded_at is null").order(created_at: :desc)}
  scope :recent, -> {where("completed_by is not null and updated_at > ?", 1.day.ago).order("updated_at desc")}

  validates :job_number, presence: true
  validates :requested_by, presence: true

  def self.survey_params
    %i(inc azm measured_depth)
  end

  def self.selected_report_params
    %i(las_export)
  end

  def self.present_report_params
    %i(report_request_types)
  end

  def self.las_export_params
    %i(start_depth end_depth)
  end

  attr_accessor :request_survey
  attr_accessor :request_reports
  attr_accessor :status

  validates_with AllPresentIfConditionValidator,
                 fields: survey_params,
                 condition: "request_survey".to_sym

  validates_with AnySelectedOrAnyPresentIfConditionValidator,
                 selected: selected_report_params,
                 present: present_report_params,
                 condition: "request_reports".to_sym,
                 error_description: "Choose a report"

  validates_with AllPresentIfConditionValidator,
                 fields: las_export_params,
                 condition: "las_export".to_sym

  def self.search jobs
    ids = []
    if jobs then jobs.each { |j| ids << j.report_request_ids } end
    where id: ids.flatten.uniq
  end

  def validate_choice
    if value_to_boolean(request_survey) || value_to_boolean(request_reports)
      true
    else
      errors.add(:base, "Select the New Survey and/or Reports option")
      false
    end
  end

  def clear_from_choices
    unless value_to_boolean(request_survey)
      ReportRequest.survey_params.each { |param| clear_value(param) }
    end

    unless value_to_boolean(request_reports)
      self.las_export = false
      self.report_request_types.destroy_all
    end

    unless value_to_boolean(las_export)
      ReportRequest.las_export_params.each { |param| clear_value(param) }
    end

    self.save
  end

  def alert!
    ReportResponse.create! alertable: self,
                           assignee: requested_by,
                           severity: 0,
                           subject: alert_subject

  end

  def alert_subject
    if failed?
      "Report Request failed because '#{description}' for #{job_number}"
    else
      "Reports are now available for #{job_number}"
    end
  end

  def failed?
    failed_at.present?
  end

  def succeeded?
    succeeded_at.present?
  end

  def report_request_type
    "General"
  end

  def job_number
    job.try(:name) || run.try(:job).try(:name)
  end

  def status
    (succeeded? && 'Succeeded') || (failed? && 'Failed') || 'Pending'
  end

  def assets(include_service)
    if include_service
      report_request_assets
    else
      report_request_assets.where("name not like '%Service%'")
    end
  end

  private

  def clear_value(param)
    self.send("#{param}=", nil)
  end

end
