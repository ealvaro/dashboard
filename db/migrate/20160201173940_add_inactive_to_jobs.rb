class AddInactiveToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :inactive, :boolean, default: false
  end
end
