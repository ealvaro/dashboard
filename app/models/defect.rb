class Defect
  include ActiveModel::Model

  attr_accessor :summary, :platform, :description
  attr_accessor :attachment, :user_name, :user_email

  validates :summary, :user_email, presence: true
end
