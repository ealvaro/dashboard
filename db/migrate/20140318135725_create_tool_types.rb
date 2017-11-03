class CreateToolTypes < ActiveRecord::Migration
  def change
    create_table :tool_types do |t|
      t.integer :number, index: true, unique: true, allow_nil: false
      t.string :klass, index: true, unique: true, allow_nil: false
      t.string :name, allow_nil: false
      t.string :description, allow_nil: false

      t.timestamps
    end
  end
end
