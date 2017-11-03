class Template < ActiveRecord::Base
  belongs_to :user
  belongs_to :job
  has_many :notifiers, as: :notifierable, dependent: :destroy

  validates :name, :job_id, :user_id, presence: true

  def clone name
    template = self.dup
    template.name = name
    if template.save
      copy_notifiers(template)
      return true
    else
      return false
    end
  end

  def import(user)
    template = self.dup
    template.user = user
    template.name = template.name + " import"

    if template.save
      copy_notifiers(template)
      template
    else
      nil
    end
  end

  private

  def copy_notifiers(template)
    self.notifiers.each do |notifier|
      notifier = notifier.dup
                         .as_json
                         .merge({ notifierable_id: template.id })
      TemplateNotifier.create(notifier)
    end
  end
end
