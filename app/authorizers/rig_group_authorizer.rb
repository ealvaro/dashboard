class RigGroupAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    true
  end

  def self.creatable_by?(user)
    user.has_role? :admin
  end

  def self.updatable_by?(user)
    user.has_role? :admin
  end

  def self.deletable_by?(user)
    user.has_role? :admin
  end

end
