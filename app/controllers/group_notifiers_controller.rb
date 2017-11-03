class GroupNotifiersController < NotifiersController
  def index
    @notifiers = GroupNotifier.visible.find_by_group params[:group]
    authorize_action_for @notifiers
    render json: @notifiers, root: false, each_serializer: NotifierSerializer
  end

  def create
    @notifier = GroupNotifier.new notifier_params
    @notifier.notifierable = RigGroup.find(notifier_params[:associated_data][:group_id])

    if @notifier.save
      render json: {message: 'ok'}
    else
      render json: {message: 'error'}, status: :bad_request
    end
  end
end
