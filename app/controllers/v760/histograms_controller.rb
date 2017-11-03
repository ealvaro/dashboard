class V760::HistogramsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    histogram = Histogram.new histogram_params
    histogram.service_number = 1 unless histogram_params[:service_number].present?
    if_success histogram, :save
  end

  def update
    histogram = Histogram.find params[:id]

    if histogram_params[:service_number].to_i == histogram.service_number
      if_success histogram, :update_attributes
    else
      histogram = Histogram.new histogram_params
      if_success histogram, :save
    end
  end

  private
    def if_success(histogram, method)
      if method == :update_attributes
        predicate = ->() { histogram.update_attributes(histogram_params) }
      else
        predicate = ->() { histogram.public_send(method) }
      end

      render_json(predicate, histogram)
    end

    def render_json(predicate, histogram)
      if predicate.call
        render json: histogram, root: false
      else
        render json: { message: histogram.errors }, status: 422
      end
    end

    def histogram_params
      params.require(:histogram).permit(:name, :job_id, :run_id,
                                        :service_number, tool_ids: [])
                                .tap do |whitelisted|
        whitelisted[:data] = params[:histogram][:data]
      end
    end
end