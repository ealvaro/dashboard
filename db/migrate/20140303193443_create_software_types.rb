class CreateSoftwareTypes < ActiveRecord::Migration
  def change
    create_table :software_types do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
