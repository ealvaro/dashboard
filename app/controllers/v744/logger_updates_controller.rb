class V744::LoggerUpdatesController < V730::LoggerUpdatesController
  include UpdateHelpers

  def create
    update = create_update_from_previous(params[:job], params[:run],
                                         object_params, "LoggerUpdate")
    update ||= LoggerUpdate.new(object_params)

    fill_info_params(update)

    render_json_with_save(update)
  end
end
