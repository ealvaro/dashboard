class Push::UsersController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def show
    render json: User.find(params[:id]), root: false
  end

  def index
    render json: User.alpha, root: false, each_serializer: UserSerializer
  end

  def alert_users
    render json: Notification.users, root: false, each_serializer: UserSerializer
  end

  def roles
    user = User.where("lower(email) = ?", params[:email].downcase ).take.try(:authenticate, params[:password])
    if user
      render json: user.roles.select{ |role| Role.lconfig_roles.include?( role ) }.to_json, status: 200
    else
      render json: {errors: "Invalid user credentials"}, status: 401
    end
  end

  def permissions
    if %w(Notifier).include? params[:feature]
      klass = Object.const_get params[:feature]
      render json: {params[:feature]=>{create: current_user.can_create?(klass),
                                       read: current_user.can_read?(klass),
                                       update: current_user.can_update?(klass),
                                       delete: current_user.can_delete?(klass)}}
    else
      render json: {errors: "invalid feature"}, status: :bad_request
    end
  end

  def logged_in_user
    render json: current_user, root: false
  end

  def update
    @user = User.find(params[:id])
    if params[:password] || params[:password_confirmation]
      @user.update_attributes password: params[:password], password_confirmation: params[:password_confirmation]
    end
    @user.update_attributes settings: params[:settings]

    # if params[:subscriptions]
    #   for subscription in params[:subscriptions]
    #     Subscription.find(subscription["id"]).update_attributes! job_id: subscription["job_id"],
    #                                                              run_id: subscription["run_id"],
    #                                                              interests: subscription["interests"],
    #                                                              threshold_setting_id: subscription["threshold_setting"].try(:[], "id")
    #   end
    # end
    render json: @user, root: false
  end

  def destroy
    @user = User.find( params[:id] )
    @user.destroy!
    render json: {}
  end

  def export_csv
    current_user.create_export! params[:objects_array]
    render json: current_user.exports.last
  end
end
