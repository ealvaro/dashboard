class V750::GammasController < V730::GammasController
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
          if gamma_params[:new_measured_depth]
            @gamma.measured_depth = gamma_params[:new_measured_depth]
          end
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

  def strong_params(gamma_params)
    gamma_params.permit(
      :id, :run_id, :measured_depth, :count, :edited_count, :new_measured_depth
    )
  end

end
