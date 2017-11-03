class V760::ReceiverUpdatesController < V744::ReceiverUpdatesController
  # Only the 'core' data is sent here. Lengthy formats like pulse_data are
  # split off to a new route, allowing them to be sent at different priorities.
  def create_core
    update = create_core_update

    fill_info_params(update)
    update.table = params[:table]
    update.merge_tool_face_data!(params[:tool_face_data])
    update.pulse_data = []
    update.fft = []

    render_json_with_save(update)
  end

  # Provides FFT data.
  def create_fft
    update = create_update
    update.time = params[:time_stamp]
    update.pulse_data = []
    update.fft = params[:fft]

    if update.save
      render json: update.to_json(only: [:id])
    else
      render json: update.errors, status: :bad_request
    end
  end

  # Splits off the pulse data into its own route, to allow for the client
  # to send it with different priority and frequency from the core updates.
  def create_pulse
    update = create_update
    update.time = params[:time_stamp]
    update.fft = []
    # later, add to params_list
    update.low_pulse_threshold = params[:low_pulse_threshold]

    update.save_as_compressed(params[:pulses],
                              params[:sample_rate],
                              params[:pulse_start_time])

    if update.save
      render json: update.to_json(only: [:id])
    else
      render json: update.errors, status: :bad_request
    end
  end

  protected

  def create_update
    update_class = update_class_from_type params[:receiver_type]
    update = create_update_from_previous(params[:job], params[:run],
                                         object_params, update_class.to_s)
  end

  def create_core_update
    update_class = update_class_from_type params[:receiver_type]
    update = create_update
    update ||= update_class.new(object_params)
  end

  # From 744, allows uid and doesn't allow low_pulse_threshold
  def param_list
    super - [:low_pulse_threshold] + [:uid]
  end
end
