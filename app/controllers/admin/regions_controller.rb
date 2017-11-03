module Admin
  class RegionsController < BaseAdminController

    def index
      @regions = Region.all
    end

    def new
      @region = Region.new
    end

    def edit
      @region = Region.find(params[:id])
    end

    def create
      @region = Region.new(region_params)
      if @region.save
        redirect_to admin_regions_path, notice: "Created Region"
      else
        render :new
      end
    end

    def update
      @region = Region.find(params[:id])
      if @region.update_attributes(region_params)
        redirect_to admin_regions_path, notice: "Updated Region"
      else
        render :edit
      end
    end

    private

    def region_params
      params.require(:region).permit(:name, :active)
    end
  end
end
