class TemplateNotifiersController < NotifiersController
  def index
    @notifiers = TemplateNotifier.visible.find_by_template params[:template_id]
    authorize_action_for @notifiers
    render json: @notifiers, root: false, each_serializer: NotifierSerializer
  end

  def create
    @notifier = TemplateNotifier.new notifier_params
    @notifier.notifierable = Template.find(notifier_params[:associated_data][:template_id])

    if @notifier.save
      render json: {message: 'ok'}
    else
      render json: {message: 'error'}, status: :bad_request
    end
  end
end
