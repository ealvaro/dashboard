class CorrectedNotification < Alert
  validates :alertable_id, presence: true
end
