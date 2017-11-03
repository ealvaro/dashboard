class RemoveJoinTableRigGroupsNotifiers < ActiveRecord::Migration
  def change
    drop_join_table :rig_groups, :notifiers
  end
end
