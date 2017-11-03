class AddJobNumberToEvent < ActiveRecord::Migration
  def change
    add_column :events, :job_number, :string
  end
end
