class V770::NotificationsController < V750::NotificationsController
  def index
    if value_to_boolean(params[:all])
      @notifications = (@notifications && @notifications.all) || Notification.all
      @notifications = filter_template_notifications(@notifications)
    elsif value_to_boolean(params[:following])
      @notifications = Notification.following(current_user)
      @notifications = filter_template_notifications(@notifications, true).active
    elsif value_to_boolean(params[:completed])
      @notifications = (@notifications && @notifications.completed) || Notification.completed
      @notifications = filter_template_notifications(@notifications).completed
    else value_to_boolean(params[:active])
      @notifications = (@notifications && @notifications.active) || Notification.active
      @notifications = filter_template_notifications(@notifications).active
    end

    if params[:keyword].present?
      @notifications = @notifications.search params[:keyword]
    end

    render json: @notifications.page(params[:page]),
           meta: { pages: @notifications.page(params[:page]).total_pages }
  end

  private

    def filter_template_notifications notifications, following=false
      ids = notifications.not_template.pluck(:id)

      if following
        ids += Notification.followed_template_notifications(current_user)
      else
        ids += Notification.template_notifications_for_user(current_user)
      end

      Notification.where(id: ids)
    end
end
