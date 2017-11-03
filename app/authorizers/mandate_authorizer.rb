class MandateAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :mandates
  end

end
