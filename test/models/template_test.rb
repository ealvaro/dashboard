require "test_helper"

class TemplateTest < ActiveSupport::TestCase
  test 'can clone template with notifiers' do
    job = create :job
    user = create :user
    template = create :template, user: user, job: job
    notifier = create :template_notifier, notifierable: template
    assert template.clone "some name"
    assert_equal Template.count, 2
    assert Template.last.id != template.id
    assert_equal TemplateNotifier.count, 2
    assert TemplateNotifier.last.id != notifier.id
  end

  test 'can import template' do
    job = create :job
    user0 = create :user
    user1 = create :user
    template = create :template, user: user0, job: job

    assert_difference('Template.count') do
      template.import(user1)
    end
    refute_equal template.id, Template.last.id
    assert_equal user1.id, Template.last.user.id
  end

  test 'can import template with notifiers' do
    job = create :job
    user0 = create :user
    user1 = create :user
    template = create :template, user: user0, job: job
    notifier = create :template_notifier, notifierable: template

    template.import(user1)
    assert_equal TemplateNotifier.count, 2
    assert TemplateNotifier.last.id != notifier.id
  end
end
