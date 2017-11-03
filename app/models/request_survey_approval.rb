class RequestSurveyApproval < Alert
  validates :alertable_id, presence: true

  def alertable_link
    if alertable.accepted? || alertable.declined?
      Rails.application.routes.url_helpers.survey_path(alertable)
    else
      Rails.application.routes.url_helpers.edit_approval_survey_path(alertable)
    end
  end
end
