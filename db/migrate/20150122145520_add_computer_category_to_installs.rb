class AddComputerCategoryToInstalls < ActiveRecord::Migration
  def change
    add_column :installs, :computer_category, :string
  end
end
