FactoryGirl.define do
  factory :receiver_setting do
    association :job
    rxdt 1
    txdt 1
  end

  factory :btr_setting, parent: :receiver_setting, class: BtrSetting do
  end

  factory :btr_slave_setting, parent: :receiver_setting, class: BtrSlaveSetting do
  end

  factory :lrx_slave_setting, parent: :receiver_setting, class: LrxSlaveSetting do
  end

end
