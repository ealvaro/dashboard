class AddTypeToTools < ActiveRecord::Migration
  def change
    add_column :tools, :type, :string
  end
end
