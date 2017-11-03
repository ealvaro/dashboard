module Admin
  class DocumentsController < BaseAdminController
    def new
      @document = ReportType.find(params[:report_type_id]).documents.build()
    end

    def edit
      @document = Document.find(params[:id])
    end

    def update
      @document = Document.find(params[:id])
      if @document.update_attributes doc_params
        return redirect_to admin_report_type_path @document.report_type
      else
        render :edit
      end
    end

    def create
      @document = ReportType.find(params[:report_type_id]).documents.create(doc_params)
      if @document.valid?
        return redirect_to admin_report_type_path @document.report_type
      else
        render :new
      end
    end

    private

    def doc_params
      params.require(:document).permit(:name, :active)
    end
  end
end
