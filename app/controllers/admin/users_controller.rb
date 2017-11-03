module Admin
  class UsersController < BaseAdminController

    def index
      authorize_action_for User
      @users_json = ActiveModel::ArraySerializer.new(User.alpha, each_serializer: UserSerializer, root: false, scope: current_user).to_json
    end

    def new
      @user = User.new
      authorize_action_for @user
    end

    def edit
      @user = User.find params[:id]
      authorize_action_for @user
    end

    def update
      @user = User.find params[:id]
      authorize_action_for @user
      @user.attributes = user_params
      authorize_action_for @user
      if @user.save
        redirect_to [:admin, :users], success: "Yay!"
      else
        render :edit
      end
    end

    def create
      @user = User.new
      authorize_action_for @user
      @user.attributes = user_params
      authorize_action_for @user
      if @user.save
        redirect_to [:admin, :users], success: "Yay!"
      else
        render :new
      end
    end

    def destroy
      @user = User.find( params[:id] )
      authorize_action_for @user
      @user.destroy!
      redirect_to [:admin, :users]
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :roles=>[])
    end
  end
end
