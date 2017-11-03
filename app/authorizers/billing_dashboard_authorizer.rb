class BillingDashboardAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :billing
  end

end
