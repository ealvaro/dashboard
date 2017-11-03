class Receiver < ActiveRecord::Base
  include Authority::Abilities

  before_validation on: :create do
    size = 8
    self.uid ||= SecureRandom.hex(size)
  end

  def cache
    read_attribute(:cache) || {}
  end

  def to_param
    self.uid
  end
end
