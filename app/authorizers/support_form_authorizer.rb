class SupportFormAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :support
  end

end
