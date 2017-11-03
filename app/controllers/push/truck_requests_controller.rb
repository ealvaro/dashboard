class Push::TruckRequestsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    if params[:completed] == 'true'
      truck_requests = TruckRequest.completed.includes(:job, :region)
    elsif params[:completed] == 'false'
      truck_requests = TruckRequest.active.includes(:job, :region)
    else
      truck_requests = TruckRequest.all.includes(:job, :region)
    end

    truck_requests = truck_requests.search(params[:keyword]) if params[:keyword].present?
    truck_requests = Kaminari.paginate_array(truck_requests.sort_by_priority)
                             .page(params[:page])
    render json: truck_requests, meta: { pages: truck_requests.total_pages }
  end

  def create
    truck_request = TruckRequest.new truck_request_params
    add_associations truck_request
    truck_request.status["context"].try(:downcase!)
    truck_request.priority.try(:downcase!)

    if truck_request.save
      render json: truck_request, root: false
    else
      render json: { message: "Failed" }, status: 422
    end
  end

  def update
    truck_request = TruckRequest.find(params[:id])
    truck_request_params[:status]["context"].downcase!

    if truck_request.update_attributes(status: truck_request_params[:status])
      render json: truck_request, root: false
    else
      render json: { message: "Failed" }, status: 422
    end
  end

  private

    def truck_request_params
      params.require(:truck_request).permit(:job_id, :region_id, :priority,
                                            :user_email, :computer_identifier,
                                            :motors, :mwd_tools,
                                            :surface_equipment,
                                            :backhaul, :notes).tap do |whitelisted|
        whitelisted[:status] = params[:truck_request][:status]
      end
    end

    def add_associations truck_request
      job = Job.find truck_request_params[:job_id]
      region = Region.find truck_request_params[:region_id]
      truck_request.job = job
      truck_request.region = region
    end
end