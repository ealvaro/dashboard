class V744::ReceiverUpdatesController < V730::ReceiverUpdatesController
  include UpdateHelpers

  # Focuses on reducing the size of data sent in; starts by copying
  # the last update and fills over any new data that comes in.
  #
  # In addition, the pulse data is sent in a compressed format.
  def create
    update_class = update_class_from_type params[:receiver_type]
    update = create_update_from_previous(params[:job], params[:run],
                                         object_params, update_class.to_s)
    update ||= update_class.new(object_params)

    fill_info_params(update)

    update.table = params[:table]
    update.merge_tool_face_data!(params[:tool_face_data])

    compressed = params[:compressed_pulse_data] || {}
    update.save_as_compressed(compressed["values"],
                              compressed["sample_rate"],
                              compressed["time_stamp"])

    render_json_with_save(update)
  end
end
