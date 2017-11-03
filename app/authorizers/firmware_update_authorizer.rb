class FirmwareUpdateAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :"firmware-updates"
  end

end
