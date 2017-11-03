class AddStartDepthToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :start_depth, :decimal
    add_column :surveys, :accepted_by_id, :integer
    add_column :surveys, :declined_by_id, :integer
  end
end
