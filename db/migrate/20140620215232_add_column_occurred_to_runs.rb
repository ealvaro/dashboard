class AddColumnOccurredToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :occurred, :datetime
  end
end
