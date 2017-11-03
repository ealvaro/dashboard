class AddAssetsToEvents < ActiveRecord::Migration
  def change
    create_table :event_assets do |t|
      t.references :event
      t.string :file
    end

    remove_column :events, :asset
  end
end
