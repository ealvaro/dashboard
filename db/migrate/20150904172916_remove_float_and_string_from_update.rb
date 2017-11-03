class RemoveFloatAndStringFromUpdate < ActiveRecord::Migration
  def change
    remove_column :updates, :float, :string
    remove_column :updates, :string, :string
  end
end
