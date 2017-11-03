class Push::InvoicesController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json

  def new
    render json: Invoice.new, root: false
  end

  def create
    @invoice = Invoice.new
    @invoice = perform_update! @invoice
    render json: @invoice, root:false
  end

  def update
    @invoice = Invoice.find(params[:invoice][:id])
    @invoice = perform_update! @invoice
    render json: @invoice, root:false
  end

  def index
    render json: Invoice.all, root: false
  end

  def show
    render json: Invoice.find( params[:id] ), root:false
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    return render json: {message: "cannot destroy this invoice"}, status: 404 unless @invoice.status == 'draft'
    Invoice.transaction do
      @invoice.cleanup_runs
      @invoice.runs.each do |run|
        run.damages.destroy_all
      end
      @invoice.destroy!
    end
    render json: {index_url: invoices_path}
  end

  private

  def perform_update!(invoice)
    Invoice.transaction do
      date = !params[:invoice][:date_of_issue].blank? ? Time.strptime(params[:invoice][:date_of_issue], "%m-%d-%Y") : invoice.date_of_issue
      invoice.assign_attributes "number" => params[:invoice][:number],
                                "discount_percent_as_billed" => params[:invoice][:discount_percent_as_billed].to_f,
                                "multiplier_as_billed" => params[:invoice][:multiplier_as_billed].to_f,
                                "date_of_issue" => date,
                                "discount_in_cents" => params[:invoice][:discount] * 100,
                                "total_in_cents" => params[:invoice][:total] * 100
      invoice.update_attributes!( status: params[:invoice][:status] ) if params[:invoice][:status]
      invoice.remove_runs!
      for billed_run in params[:invoice][:runs]
        hash = billed_run.to_hash
        run = Run.find hash["id"]
        run.update_attributes_from_invoice hash
        @invoice.runs << run
      end
      invoice.raw_invoice = params.permit!["invoice"]
      invoice.raw_invoice["date_of_issue"] = date
      invoice.save
    end
    invoice
  end
end
