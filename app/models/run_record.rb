class RunRecord < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :tool
  belongs_to :run
  belongs_to :import
  has_many   :images, as: :imageable

  validates_presence_of :tool, :run
end
