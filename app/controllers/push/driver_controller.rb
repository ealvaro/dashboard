class Push::DriverController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :ensure_json_format, only: :receipts

  respond_to :json
  ## Return list of all active mandates
  ## Disabled
  def mandates
    render json: []
  end

  def receipts
    receipts = params[:receipts].map do |receipt_params|
      Receipt.new.tap do |r|
        utc = receipt_params[:timestamp_utc]
        r.mandate_token = receipt_params[:mandate_token]
        r.tool_serial = receipt_params[:tool_serial]
        r.timestamp_utc = Time.at(utc.to_i) if utc
        r.save
      end
    end
    respond_with receipts, location: nil , root: 'receipts', each_serializer: ReceiptSerializer
  end
  
  private

  def ensure_json_format
    unless params[:receipts].is_a? Array
      render json: {errors: "receipts must be an array"}, status: 422
    end
  end
  
end
