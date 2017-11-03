class CreateNotifiers < ActiveRecord::Migration
  def change
    create_table :notifiers do |t|
      t.string :name
      t.string :type
      t.json :configuration

      t.timestamps
    end

    create_table :notifications do |t|
      t.references :notifier, index: true
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
