class AddThresholdSettingToSubscriptions < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :threshold_setting, index: true
  end
end
