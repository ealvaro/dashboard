class ReportType < ActiveRecord::Base
  has_many :documents
  has_many :events

  validates :name, presence: true, allow_blank: false

  scope :active, -> { where( active: true )}
  scope :inactive, -> { where( "active = false or active is null" )}
end