class DefectNotifier < ActionMailer::Base
  default from: ENV["FROM_EMAIL"]

  def defect_email(defect)
    @defect = defect
    if @defect.attachment.present?
      file_data = @defect.attachment.tempfile.read
      attachments[@defect.attachment.original_filename] = file_data
    end

    users = User.select{ |u| u.roles.include?("Quality Control") }
    users.each { |u| mail(to: u.email, subject: "New bug report").deliver }
  end
end
