module Admin
  class ReportTypesController < BaseAdminController
    def index
      @report_types = ReportType.all
    end

    def show
      @report_type = ReportType.find(params[:id])
      @documents = @report_type.documents.active
    end

    def new
      @report_type = ReportType.new
    end

    def edit
      @report_type = ReportType.find(params[:id])
    end

    def update
      @report_type = ReportType.find(params[:id])
      if @report_type.update_attributes rt_params
        return redirect_to admin_report_types_path
      else
        render :edit
      end
    end

    def create
      @report_type = ReportType.create rt_params
      if @report_type.valid?
        return redirect_to admin_report_types_path
      else
        render :new
      end
    end

    private

    def rt_params
      params.require(:report_type).permit(:name, :active)
    end
  end
end
