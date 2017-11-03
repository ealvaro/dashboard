class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :job_id
      t.datetime :occurred

      t.timestamps
    end
  end
end
