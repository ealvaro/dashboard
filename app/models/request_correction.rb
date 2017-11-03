class RequestCorrection < Alert
  validates :alertable_id, presence: true
end
