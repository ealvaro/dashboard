require 'type_conversion'

class V750::NotificationsController < ApplicationController
  include TypeConversion
  include TokenAuthenticating
  respond_to :json

  before_action :set_notifications, only: [:index]

  def index
    set = false
    if value_to_boolean(params[:all])
      notifications = @notifications || Notification.all
      set = true
    else
      @notifications ||= Notification
      notifications = []

      %w(completed active).each do |filter|
        if value_to_boolean(params[filter.to_sym])
          notifications = @notifications.send(filter)
          set = true
          break
        end
      end
    end

    notifications = @notifications.active unless set

    render json: notifications, root: false
  end

  def search
    notifications = Notification.search params[:keyword]
    render json: notifications, root: false
  end

  def complete
    status = params[:status]
    if params[:notification_id].present?
      notification = complete_notification(params[:notification_id], status)
    elsif params[:notification_ids].present?
      params[:notification_ids].each do |notification_id|
        complete_notification(notification_id, status)
      end
    end

    render json: notification, root: false
  end

  protected

  def set_notifications
    job_number = params[:job_number]
    if job_number.present?
      @notifications = Notification.by_job_number(job_number)
    elsif params[:job_numbers].present?
      @notifications = Notification.by_job_numbers(params[:job_numbers])
    end
  end

  def complete_notification(notification_id, status)
    notification = Notification.find(notification_id)
    if notification.present?
      mark_deleted(notification, status)
      Pusher["UpdateNotification"].trigger("update", {"job" => notification.job_number})
    end
    notification
  end

  def mark_deleted(notif, status)
    notif.complete!
    notif.cleared_by_id = current_user.id
    notif.completed_status = status
    notif.save
  end
end
