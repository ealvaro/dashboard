class ToolAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :tools
  end

  def self.deletable_by?(user)
    user && user.has_role?( :superuser )
  end

end
