class CreateInstalls < ActiveRecord::Migration
  def change
    create_table :installs do |t|
      t.string :application_name, index: true
      t.string :version
      t.string :ip_address
      t.string :key, index: true

      t.timestamps
    end
  end
end
