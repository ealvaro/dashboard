class ThresholdNotification < Alert
  validates :alertable_id, presence: true

  def alertable_link
    Rails.application.routes.url_helpers.receiver_path(id:alertable.uid)
  end

  def alertable_json
    alertable.as_json.merge(show_url: alertable_link)
  end

  def pusher_json
    as_json
  end
end