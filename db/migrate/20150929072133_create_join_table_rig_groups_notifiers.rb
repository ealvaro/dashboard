class CreateJoinTableRigGroupsNotifiers < ActiveRecord::Migration
  def change
    create_join_table :rig_groups, :notifiers do |t|
      # t.index [:rig_group_id, :notifier_id]
      # t.index [:notifier_id, :rig_group_id]
    end
  end
end
