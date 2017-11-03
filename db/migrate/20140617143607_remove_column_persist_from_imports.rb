class RemoveColumnPersistFromImports < ActiveRecord::Migration
  def up
    remove_column :imports, :persist
  end

  def down
    add_column :imports, :persist, :boolean
  end
end
