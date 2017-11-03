class ReportResponse < Alert
  validates :alertable_id, presence: true

  def alertable_json
    tmp = alertable.as_json
    tmp.merge! job: {name: alertable.job.name, show_url: Rails.application.routes.url_helpers.job_path(alertable.job)}
    tmp.merge! run: {number: alertable.run.number, show_url: Rails.application.routes.url_helpers.run_path(alertable.run)} if alertable.run
    tmp
  end

  def alertable_link
    Rails.application.routes.url_helpers.job_path(alertable.job)
  end

  def pusher_json
    as_json
  end
end
