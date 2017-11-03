class SideTrack < ActiveRecord::Base
  belongs_to :run

  validates :run_id, presence: true
  validates :number, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 255}, uniqueness: {scope: :run_id}
end
