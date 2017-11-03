class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.integer :user_id
      t.integer :job_id

      t.timestamps
    end
  end
end
