require "test_helper"

class TemplateNotifierTest < ActiveSupport::TestCase
  setup do
    @user = create :user
  end

  test "can find by template" do
    job = create :job
    template = create :template, job: job, user: @user
    bad_template = create :template, job: job, user: @user
    notifier = create :template_notifier, notifierable: template
    bad_notifier = create :template_notifier, notifierable: bad_template
    assert TemplateNotifier.find_by_template(template).include?(notifier)
    assert_not TemplateNotifier.find_by_template(template).include?(bad_notifier)
  end
end
