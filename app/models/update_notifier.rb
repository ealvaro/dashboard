require 'type_conversion'

class UpdateNotifier < Notifier
  extend TypeConversion

  validates :name, :configuration, presence: true

  def self.test_trigger(field_value, op, value)
    field_value.public_send(op, value)
  end

  def self.latest_updates(job)
    Update.children.inject({}) { |h, u| h[u.to_s] = u.last_update_for_job(job); h }
  end

  def self.trigger_with_params(job, rig)
    updates = self.latest_updates(job.name)

    trigger_notifiers(GlobalNotifier.visible, updates)

    rig_notifiers = RigNotifier.visible.find_by_rig(rig) unless rig.blank?
    trigger_notifiers(rig_notifiers, updates) unless rig_notifiers.blank?

    group_notifiers = GroupNotifier.visible.find_by_rig(rig) unless rig.blank?
    trigger_notifiers(group_notifiers, updates) unless group_notifiers.blank?

    templates = Template.where(job: job)
    template_notifiers = TemplateNotifier.visible.find_by_templates(templates) unless templates.blank?
    trigger_notifiers(template_notifiers, updates) unless template_notifiers.blank?
  end

  def self.trigger(update)
    self.trigger_with_params(update.job, update.rig)
  end

  def self.trigger_from_last_updates
    # Called by heroku rake task
    Job.active.each { |job| self.trigger_with_params(job, '') }
  end

  def self.trigger_conditions(conditions, boolean, updates)
    trigger = false
    boolean.downcase!

    conditions.each do |condition|
      if condition['type'].downcase == 'condition'
        update = updates[condition['update']]
        if update.present? && self.allowed_operators.include?(condition['operator'])
          field_value = field_value(condition['field'], update)
          if field_value != nil
            value = make_value(condition['value'], condition['valueOp'],
                               condition['field'])
            trigger = test_trigger(field_value, condition['operator'], value)
          else
            trigger = false
          end
        else
          trigger = false
        end
      elsif condition['type'].downcase == 'grouping'
        trigger = self.trigger_conditions(condition['conditions'],
                                          condition['boolean'],
                                          updates)
      else
        trigger = false
      end

      if (!trigger && boolean == 'and') || (trigger && boolean == 'or')
        break
      end
    end

    trigger
  end

  def self.trigger_notifiers(notifiers, updates)
    notifiers.each do |notifier|
      trigger = self.trigger_conditions(notifier.configuration['conditions'],
                                        notifier.configuration['boolean'],
                                        updates)
      if trigger
        description = notifier.status_from_notifiable(updates)

        update = updates.keep_if { |k,v| v.present? }.try(:first).try(:second)
        if update.present?
          notifications = Notification.by_job_number(update.job_number).active.by_notifier(notifier).readonly(false)
          if notifications.count > 0
            notification = notifications.first
            if notification.notifiable != update || notification.description != description
              notification.description = description
              notification.notifiable = update
              notification.save
            end
          else
            Notification.create(notifier: notifier, notifiable: update,
                                description: description)

            Pusher["UpdateNotification"].trigger("create",
                                                 {"job"=>update.job_number})
          end
        end
      end
    end
  end
end
