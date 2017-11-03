class CustomerAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :billing
  end

  def self.creatable_by?(user)
    user.has_role? :billing
  end

  def self.updatable_by?(user)
    user.has_role? :billing
  end

  def self.deletable_by?( user )
    user.has_role?( :superuser )
  end
end
