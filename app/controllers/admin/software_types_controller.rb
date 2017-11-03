module Admin
  class SoftwareTypesController < BaseAdminController

    def index
      authorize_action_for SoftwareType
      @software_types = SoftwareType.alpha
    end

    def new
      @software_type = SoftwareType.new
      authorize_action_for @software_type
    end

    def create
      @software_type = SoftwareType.new
      authorize_action_for @software_type
      @software_type.attributes = software_type_params
      authorize_action_for @software_type
      if @software_type.save
        redirect_to [:admin, :software_types], notice: "Created!"
      else
        render :new
      end
    end

    def edit
      @software_type = SoftwareType.find(params[:id])
      authorize_action_for @software_type
    end

    def update
      @software_type = SoftwareType.find(params[:id])
      authorize_action_for @software_type
      @software_type.attributes = software_type_params
      authorize_action_for @software_type
      if @software_type.save
        redirect_to [:admin, :software_types], notice: "Created!"
      else
        render :edit
      end
    end

    def destroy
      @software_type = SoftwareType.find(params[:id])
      authorize_action_for @software_type
      @software_type.destroy
        redirect_to [:admin, :software_types], notice: "Removed"
    end

    protected

    def software_type_params
      params.require(:software_type).permit(:name)
    end
  end
end
