class V730::GammasController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    errors = []
    if params[:gammas].present?
      params[:gammas].each do |gamma_params|
        error = create_gamma(gamma_params)
        errors.append(error) if error.present?
      end
    else
      error = create_gamma(params)
      errors.append(error) if error.present?
    end

    if errors.present?
      render json: { errors: errors }, status: 400
    else
      render json: { message: "Gamma(s) successfully added" }
    end
  end

  def edits
    if run
      render json: Gamma.edited.where(run: run), root: false
    else
      render json: { error: "You must include a valid job_number or job_id" },
             status: 400
    end
  end

  def request_edit
    @gamma = Gamma.find_by(id: params[:id])
    if @gamma.present?
      count = @gamma.count
      if @gamma.edited_count.present? &&
         !fuzzy_equal(@gamma.count, @gamma.edited_count)
        count = @gamma.edited_count
      end
      unless fuzzy_equal(params[:count], count)
        @gamma.edited_count = params[:count]
        @gamma.save

        push_gamma

        render json: { message: "Gamma successfully updated" }
      else
        render json: { message: "Nothing to change" }
      end
    else
      render json: { error: "You must include a valid id" },
             status: 400
    end
  end

  def update
    error = update_gamma(params)
    if error.present?
      render json: { error: error }, status: 400
    else
      render json: { message: "Gamma successfully updated" }
    end
  end

  def updates
    errors = []
    params[:gammas].each do |gamma_params|
      error = update_gamma(gamma_params)
      errors.append(error) if error.present?
    end

    if errors.present?
      render json: { errors: errors }, status: 400
    else
      render json: { message: "Gammas successfully updated" }
    end
  end

  def refresh
    gammas = Gamma.by_job_id(job.try(:id)).order("measured_depth desc").limit(3000).reverse
    data = gammas.map { |gamma| to_hash(gamma) }
    render json: pusher_params(job).merge(objects: data)
  end

  def test_gamma
    job = Job.find(params[:job_id])
    TestGamma.new(job).publish_notify
    render json: { message: "Gamma test events sent" }
  end

  protected

  def create_gamma(gamma_params)
    run = run_with_params(gamma_params)
    if run
      @gamma = Gamma.create(strong_params(gamma_params).merge(run_id: run.id,
                                                              edited_count: gamma_params[:count]))
      if @gamma
        push_gamma
      else
        "Error creating gamma for #{gamma_params.to_s}"
      end
    else
      "You must include a valid job_number or job_id and count for #{gamma_params.to_s}"
    end
  end

  def update_gamma(gamma_params)
    run = run_with_params(gamma_params)
    @gamma = Gamma.by_fuzzy_measured_depth(gamma_params[:measured_depth])
                  .find_by(run_id: run.try(:id),
                           count: gamma_params[:old_count])

    @gamma ||= Gamma.find_by(id: gamma_params[:id])
    if @gamma.present?
      if gamma_params[:count_missing]
        @gamma.edited_count = @gamma.count
        @gamma.save
        push_gamma
      else
        if gamma_params[:count]
          @gamma.count = gamma_params[:count]
          @gamma.edited_count = gamma_params[:count]
          @gamma.save

          push_gamma
        else
          "You must include a count for #{gamma_params.to_s}"
        end
      end
    else
      "You must include a valid id or job/run/measured_depth/old_count for #{gamma_params.to_s}"
    end
  end

  def to_hash(gamma)
    hash = gamma.instance_values["attributes"]
    %w(count edited_count measured_depth).each do |field|
      hash[field] = hash[field].to_f
    end
    %w(id run_id).each do |field|
      hash[field] = hash[field].to_i
    end

    hash
  end

  def pusher_params(job)
    { updated_at: DateTime.now.utc.to_s, job_number: job.name }
  end

  def push_gamma
    data = pusher_params(@gamma.job).merge to_hash(@gamma)

    Pusher["gamma-#{@gamma.job.name.downcase}"].trigger("update", data)
  end

  def job
    job_with_params(params)
  end

  def job_with_params(params)
    gamma = Gamma.find_by(id: params[:id])
    run = gamma.run if gamma

    run ||= Run.find_by(id: params[:run_id])
    job ||= run.try(:job)

    job ||= Job.find(params[:job_id]) if params[:job_id]
    job ||= Job.fuzzy_find(params[:job_number]) if params[:job_number]
    job
  end

  def run
    run_with_params(params)
  end

  def run_with_params(params)
    run = Run.find params[:run_id] if params[:run_id]
    job = job_with_params(params)
    run ||= Run.fuzzy_find(job, params[:run_number]) if job && params[:run_number]
    run
  end

  def strong_params(gamma_params)
    gamma_params.permit(
      :id, :run_id, :measured_depth, :count, :edited_count
    )
  end

  private
  def fuzzy_equal(a, b)
    eps = 0.000001
    a.to_f.between?(b - eps, b + eps)
  end

end
