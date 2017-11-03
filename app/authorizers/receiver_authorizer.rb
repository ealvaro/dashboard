class ReceiverAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :receivers
  end

end
