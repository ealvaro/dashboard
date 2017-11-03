class ReportRequestAuthorizer < ApplicationAuthorizer

  def self.readable_by?(user)
    user.has_role? :"report-requests"
  end

end
