class ReportRequestType < ActiveRecord::Base
  has_and_belongs_to_many :report_requests

  validates :name, presence: true, allow_nil: false

  attr_accessor :display_name

  def display_name
    if scaling.present?
      "#{name} #{scaling}"
    else
      name
    end
  end
end
