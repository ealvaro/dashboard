class GlobalNotifiersController < NotifiersController
  def index
    @notifiers = GlobalNotifier.visible
    authorize_action_for @notifiers
    render json: @notifiers, root: false, each_serializer: NotifierSerializer
  end

  def create
    @notifier = GlobalNotifier.new notifier_params

    if @notifier.save
      render json: {message: 'ok'}, status: 200
    else
      render json: {message: 'error'}, status: :bad_request
    end
  end
end
