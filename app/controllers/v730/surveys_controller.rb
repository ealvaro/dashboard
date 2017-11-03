class V730::SurveysController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    measured_depth = params.try(:[], :measured_depth)
    if measured_depth.present? && run.present?
      found = Survey.find_by(measured_depth_in_feet: measured_depth, run: run)
      unless found
        survey = Survey.create strong_params.merge(measured_depth_in_feet: measured_depth,
                                                   run_id: run.id)
        render json: survey, root: false
      else
        render json: {message: "Resource already exists, try update"},
               status: 403
      end
    else
      render json: {message: "You must include the job/run numbers and the measured depth"},
             status: 404
    end
  end

  def update
    measured_depth = params.try(:[], :measured_depth)
    found = Survey.find_by(measured_depth_in_feet: measured_depth, run: run)
    if found
      new = Survey.new
      new.measured_depth_in_feet = measured_depth
      new.run = run
      new.user = current_user
      new.key = found.key
      new.version_number += found.versions.last.version_number

      new.assign_attributes update_params
      unless Survey.business_exists?(new)
        new.save!
        unless new.accepted? || new.declined?
          new.alert!
        end
        render json: {message: "The future survey matching this data was updated"}
      else
        render json: {message: "Nothing to update"}
      end
    else
      render json: {message: "You must include the job/run numbers and the measured depth"},
             status: 404
    end
  end

  protected

  def strong_params
    params.permit(
      :id, :measured_depth_in_feet, :inclination, :azimuth, :job_id, :run_id,
      :start_depth, :gx, :gy, :gz, :hx, :hy, :hz,
      :dip_angle, :north, :east, :tvd, :horizontal_section, :dog_leg_severity
    )
  end

  def update_params
    params.permit(
      :inclination, :azimuth,
      :start_depth, :gx, :gy, :gz, :hx, :hy, :hz,
      :dip_angle, :north, :east, :tvd, :horizontal_section, :dog_leg_severity
    )
  end

  def job
    job_id = params.try(:[],:job_id)
    job = Job.find(job_id) if job_id
    job_number = params.try(:[],:job_number)
    job ||= Job.fuzzy_find(job_number) if job_number
    job
  end

  def run
    run_id = params.try(:[],:run_id)
    run = Run.find(run_id) if run_id
    run_number = params.try(:[],:run_number)
    run ||= Run.fuzzy_find(job, run_number) if job && run_number
    run
  end
end
