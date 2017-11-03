class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :alertable_type
      t.integer :alertable_id
      t.belongs_to :requester, index: true
      t.belongs_to :assignee, index: true
      t.string :subject
      t.text :description
      t.datetime :ignored_at
      t.timestamp :completed_at
      t.integer :severity
      t.string :type
      t.timestamps
    end
  end
end
