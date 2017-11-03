class AddReporterContextToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reporter_context, :string
  end
end
