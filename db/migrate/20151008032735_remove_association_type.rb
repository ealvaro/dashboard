class RemoveAssociationType < ActiveRecord::Migration
  def change
    remove_column :notifiers, :association_type, :integer
  end
end