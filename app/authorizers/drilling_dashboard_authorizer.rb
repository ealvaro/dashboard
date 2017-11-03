class DrillingDashboardAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :"directional-drilling"
  end

  def self.creatable_by?(user)
    user.has_role? :"directional-drilling"
  end

  def self.updatable_by?(user)
    user.has_role? :"directional-drilling"
  end

end
