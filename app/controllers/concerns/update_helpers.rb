module UpdateHelpers
  def update_class_from_type(update_type)
    case update_type
    when "btr-receiver"
      BtrReceiverUpdate
    when "btr-control-receiver"
      BtrControlUpdate
    when "em-receiver"
      EmReceiverUpdate
    else # "leam-receiver"
      LeamReceiverUpdate
    end
  end

  def create_update_from_previous(job_number, run_number, object_params, type)
    # fill in from previous data if possible
    job = Job.fuzzy_find(job_number)
    if job
      last_update = job.last_update_for_type type
      if last_update.present? && last_update.run_number == run_number
        update = last_update.dup if last_update
        if update.present?
          # remove nil values so assign_attributes won't write over good values
          object_params.select! { |k,v| v.present? }
          update.assign_attributes(object_params.merge({published_at:nil}))
        end
        update
      end
    end
  end

  def render_json_with_save(update)
    if update.save
      Rig.fuzzy_find(update.rig_name).try(:touch)
      UpdateNotifier.trigger(update)
      render json: update.to_json(only: [:id])
    else
      render json: update.errors, status: :bad_request
    end
  end
end