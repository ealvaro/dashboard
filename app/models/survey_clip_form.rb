class SurveyClipForm
  include ActiveModel::Model

  attr_accessor :measured_depth, :gx, :gy, :gz, :hx, :hy, :hz, :job_id
  attr_accessor :pasted_data, :user

  def apply_updates!
    return if pasted_data.blank?

    surveys = []
    import_run = SurveyImportRun.create
    
    CSV.parse(pasted_data).each do |row|
      existing_survey = Survey.find_by(job_id: job_id, measured_depth_in_feet: row[0])
      next unless existing_survey
      survey = Survey.new(existing_survey.attributes.except("created_at", "updated_at", "id"))
      survey.id = nil
      survey.key = existing_survey.key
      survey.version_number += existing_survey.versions.last.version_number
      survey.user = user
      survey.gx = row[1]
      survey.gy = row[2]
      survey.gz = row[3]
      survey.hx = row[4]
      survey.hy = row[5]
      survey.hz = row[6]
      survey.survey_import_run = import_run
      survey.save
      surveys << survey
    end
    surveys
  end

end
