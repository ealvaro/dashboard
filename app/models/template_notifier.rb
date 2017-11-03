class TemplateNotifier < UpdateNotifier
  alias_attribute :template, :notifierable

  def self.find_by_templates template_ids
    return [] unless template_ids.present?
    self.where(notifierable_id: template_ids)
  end

  def self.find_by_template template_id
    self.find_by_templates([template_id])
  end
end
