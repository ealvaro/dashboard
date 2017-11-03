class Push::InstallsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :ensure_install_params, only: :create
  respond_to :json

  def index
    render json: Install.recent, root: false
  end

  def create
    the_params = install_params.merge(ip_address: request.remote_ip)

    respond_with Install.for_key_or_create(the_params), root:false, location:nil
  end

  def recent_tools
    result = {}
    types = {}
    Tool.where(id: Event.where( software_installation_id: params[:id] ).collect(&:tool_id)).order( created_at: :desc ).each do |t|
      unless types[t.tool_type_id]
        types[t.tool_type_id] = ToolType.find(t.tool_type_id).name
        result[types[t.tool_type_id]] = []
      end
      tt = result[types[t.tool_type_id]]
      tt << t if tt.length < 3
    end
    render json: result.collect{|k,v| v}.flatten, each_serializer: ToolSerializer, root: false
  end

  private

  def ensure_install_params
    if params[:install].blank?
      render json: {errors: ["Must have a root 'install' node"]}, status: 422
    end
  end

  def install_params
    params.require(:install).permit(:key, :application_name, :version, :team_viewer_id, :team_viewer_password, :dell_service_number,
                                    :user_email, :region, :reporter_context, :job_number, :run_number, :computer_category)
  end
end
