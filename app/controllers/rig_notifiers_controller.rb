class RigNotifiersController < NotifiersController
  def index
    rig = Rig.fuzzy_find(params[:rig_name])
    @notifiers = RigNotifier.visible.find_by_rig rig
    authorize_action_for @notifiers
    render json: @notifiers, root: false, each_serializer: NotifierSerializer
  end

  def create
    @notifier = RigNotifier.new notifier_params
    @notifier.notifierable = Rig.find(notifier_params[:associated_data][:rig_id])

    if @notifier.save
      render json: {message: 'ok'}
    else
      render json: {message: 'error'}, status: :bad_request
    end
  end
end
