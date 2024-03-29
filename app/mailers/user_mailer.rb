class UserMailer < ActionMailer::Base
  default from: ENV["FROM_EMAIL"]

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end

end
