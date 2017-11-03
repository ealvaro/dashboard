class InvoicesController < ApplicationController
  before_action :authenticate_user!

  def new
    @invoice = Invoice.new
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def index
    @invoices_json = ActiveModel::ArraySerializer.new(Invoice.all, each_serializer: InvoiceIndexSerializer ).to_json
  end

  def show
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html {
        render :show
      }
      format.pdf do
        #InvoiceMailer.invoice(@invoice.id, render_to_string(pdf: "invoice_#{DateTime.now.strftime("%m%d%Y")}", template: 'invoices/show'), ["joshua.wolfe@erdosmiller.com"]).deliver!
        return render pdf: "invoice_#{DateTime.now.strftime("%m%d%Y")}",
                      disposition: 'inline',
                      orientation: 'landscape'
      end
    end
  end

  def to_draft
    @invoice = Invoice.find params[:invoice_id]
    @invoice.update_attributes status: 'draft'
    redirect_to edit_invoice_path(@invoice)
  end
end
