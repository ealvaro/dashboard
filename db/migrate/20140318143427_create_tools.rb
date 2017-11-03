class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :uid, index: true, unique: true, allow_nil: false
      t.references :tool_type, index: true, allow_nil: false

      t.timestamps
    end
  end
end
