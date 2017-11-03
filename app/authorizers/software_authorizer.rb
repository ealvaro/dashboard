class SoftwareAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :software
  end

  def self.deletable_by?(user)
    user.has_role? :admin
  end

end
