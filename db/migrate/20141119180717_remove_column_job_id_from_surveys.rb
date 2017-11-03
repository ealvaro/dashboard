class RemoveColumnJobIdFromSurveys < ActiveRecord::Migration
  def change
    remove_column :surveys, :job_id, :integer
  end
end
