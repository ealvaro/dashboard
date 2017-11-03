class RigGroup < ActiveRecord::Base
  include Authority::Abilities

  has_and_belongs_to_many :rigs
  has_many :notifiers, as: :notifierable
  validates_presence_of :name

end
