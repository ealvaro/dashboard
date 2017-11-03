class CreateRigs < ActiveRecord::Migration
  def change
    create_table :rigs do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
