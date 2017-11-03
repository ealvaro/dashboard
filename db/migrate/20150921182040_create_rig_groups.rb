class CreateRigGroups < ActiveRecord::Migration
  def change
    create_table :rig_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
