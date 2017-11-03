class SurveyAuthorizer < ApplicationAuthorizer

  def self.default(able, user)
    user.has_role? :survey
  end

  def self.appliable_by?(user)
    user.has_role? :survey
  end

end
