class AddAssociationTypeToNotifier < ActiveRecord::Migration
  def change
    add_column :notifiers, :association_type, :integer
  end
end
