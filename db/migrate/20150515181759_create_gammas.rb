class CreateGammas < ActiveRecord::Migration
  def change
    create_table :gammas do |t|
      t.references :run, index: true
      t.float :measured_depth
      t.float :count
      t.float :edited_count

      t.timestamps
    end
  end
end
