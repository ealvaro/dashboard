class V700::JobsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def check
    hash = {}
    job = Job.find params[:job_id] if params[:job_id]
    job ||= Job.fuzzy_find params[:job_number] if params[:job_number]

    hash.merge! job: job if defined?(job)

    run = Run.find params[:run_id] if params[:run_id]
    run ||= Run.fuzzy_find(job, params[:run_number]) if job && params[:run_number]

    hash.merge! run: run if defined?(run)

    well = Well.find params[:well_id] if params[:well_id]
    well ||= Well.fuzzy_find(params[:well_name]) if params[:well_name]

    hash.merge! well: well if defined?(well)

    rig = Rig.find params[:rig_id] if params[:rig_id]
    rig ||= Rig.fuzzy_find(params[:rig_name]) if params[:rig_name]

    hash.merge! rig: rig if defined?(rig)

    client = Client.find params[:client_id] if params[:client_id]
    client ||= Client.fuzzy_find(params[:client_name]) if params[:client_name]

    hash.merge! client: client if defined?(client)

    merge_well_rig_client(hash, job)

    render json: hash, root: false
  end

  def create
    hash = {}

    job_id = params.try(:[],:job).try(:[],:id)
    job = Job.find job_id if job_id
    job_number = params.try(:[],:job).try(:[],:number)
    job ||= Job.fuzzy_find(job_number) if job_number

    if !job && !job_number.blank?
      job = Job.create!(name: job_number.strip)
    end
    hash.merge! job: job

    run_id = params.try(:[],:run).try(:[],:id)
    run = Run.find run_id if run_id
    run_number = params.try(:[],:run).try(:[],:number)
    run ||= Run.fuzzy_find(job, run_number) if job && run_number

    well_id = params.try(:[],:well).try(:[],:id)
    well = Well.find well_id if well_id
    well_name = params.try(:[],:well).try(:[],:name)
    well ||= Well.fuzzy_find(well_name) if well_name

    rig_id = params.try(:[],:rig).try(:[],:id)
    rig = Rig.find rig_id if rig_id
    rig_name = params.try(:[],:rig).try(:[],:name)
    rig ||= Rig.fuzzy_find(rig_name) if rig_name

    client_id = params.try(:[],:client).try(:[],:id)
    client = Client.find client_id if client_id
    client_name = params.try(:[],:client).try(:[],:name)
    client ||= Client.fuzzy_find(client_name) if client_name

    if job && !run && !run_number.blank?
      run = Run.create!(job:job, number: run_number)
    end
    hash.merge! run: run

    if well_name && !well
      well = Well.create!(name: well_name)
    end

    if well && run && !run.well
      run.update_attributes well: well
    end
    hash.merge! well: well

    if !rig && rig_name
      rig = Rig.create!(name: rig_name)
    end

    if run && !run.rig
      run.update_attributes rig: rig if rig && run
    end
    hash.merge! rig: rig

    if !client && client_name
      client = Client.create!(name: client_name)
    end

    if job && !job.client
      job.update_attributes client: client if client && job
    end
    hash.merge! client: client

    merge_well_rig_client(hash, job)

    render json: hash, root: false
  end

  protected

  def merge_well_rig_client(hash, job)
    if job
      hash.merge! well: job.well if job.well
      hash.merge! rig: job.rig if job.rig
      hash.merge! client: job.client if job.client
    end
  end

end
