FactoryGirl.define do
  factory :global_notifier, class: GlobalNotifier do
    name "Global Gravity"
    configuration ({ 'type'=>"grouping", 'boolean'=>"and", 'conditions' => [{ 'type'=>"condition", 'update'=>"LoggerUpdate", 'field' => "gravity", 'operator' => ">", 'value' => "1.1", 'value_op' => "" }] })
  end

  factory :rig_notifier, class: RigNotifier do
    name "Rig Gravity"
    configuration ({ 'type'=>"grouping", 'boolean'=>"and", 'conditions' => [{ 'type'=>"condition", 'update'=>"LoggerUpdate", 'field' => "gravity", 'operator' => ">", 'value' => "0.9", 'value_op' => "" }] })
  end

  factory :update_notifier, parent: :global_notifier do
  end

  factory :group_notifier, class: GroupNotifier do
    name "Group Gravity"
    configuration ({ 'type'=>"grouping", 'boolean'=>"and", 'conditions' => [{ 'type'=>"condition", 'update'=>"LoggerUpdate", 'field' => "gravity", 'operator' => ">", 'value' => "0.9", 'value_op' => "" }] })
  end

  factory :template_notifier, parent: :global_notifier, class: TemplateNotifier do
  end
end
