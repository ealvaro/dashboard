class UsersController < ApplicationController
  def show
    @user_json = UserSerializer.new(current_user, root: false).to_json
  end

  def follows
    render json: current_user.try(:follows), root: false
  end

  def follow
    current_user.follow user_params[:job]
    render json: current_user.try(:follows), root: false
  end

  def unfollow
    current_user.unfollow user_params[:job]
    render json: current_user.try(:follows), root: false
  end

  private

    def user_params
      params.require(:user).permit(:job)
    end
end
