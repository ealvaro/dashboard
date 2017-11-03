class DefectsController < ApplicationController
  def create
    @defect = Defect.new defect_params
    if @defect.valid?
      DefectNotifier.defect_email(@defect)
      redirect_to defects_path,
                  notice: "Bug report \"#{@defect.summary}\" submitted"
    else
      render :new
    end
  end

  def new
    # Jira issue collector is unsupported for IE 8/9.
    agent = request.env["HTTP_USER_AGENT"]
    if agent =~ /MSIE 8.0/ || agent =~ /MSIE 9.0/
      @defect = Defect.new(user_name: current_user.try(:name),
                           user_email: current_user.try(:email))
      @platforms = ["LConfig", "RTOC", "FA Data Viewer", "Dual Gamma",
                   "Pulser Driver", "Sensor Interface"]
    else
      redirect_to defects_path
    end
  end

  private

  def defect_params
    params.require(:defect).permit(:summary, :platform, :description,
                                   :attachment, :user_name, :user_email)
  end

end
