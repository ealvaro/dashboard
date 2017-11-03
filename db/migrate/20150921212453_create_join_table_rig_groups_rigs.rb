class CreateJoinTableRigGroupsRigs < ActiveRecord::Migration
  def change
    create_join_table :rig_groups, :rigs do |t|
      # t.index [:rig_group_id, :rig_id]
      # t.index [:rig_id, :rig_group_id]
    end
  end
end
