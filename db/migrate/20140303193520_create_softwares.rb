class CreateSoftwares < ActiveRecord::Migration
  def change
    create_table :softwares do |t|
      t.references :software_type, index: true
      t.string :version
      t.text :summary
      t.string :binary

      t.timestamps
    end
  end
end
