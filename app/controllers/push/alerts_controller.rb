class Push::AlertsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    @user = current_user || User.find_by(email: params[:email])
    render json: @user.alerts.recent.order(created_at: :desc), root: false, each_serializer: AlertSerializer
  end

  def ignore
    @alert = Alert.find(params[:alert_id])
    @alert.ignore!
    render json: @alert, root: false
  end

  def complete
    @alert = Alert.find(params[:alert_id])
    @alert.complete!
    render json: @alert, root: false
  end

  def test
    @object = ReportRequest.last
    @object.update_attributes description: "Test description"
    @object.alert!
    render json: []
  end
end
