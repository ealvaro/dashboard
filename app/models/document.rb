class Document < ActiveRecord::Base
  belongs_to :report_type
  validates :name, presence: true, allow_blank: false

  scope :active, -> { where( active: true )}
  scope :inactive, -> { where( "active = false or active is null" )}
end