class InstallAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :installations
  end

end
