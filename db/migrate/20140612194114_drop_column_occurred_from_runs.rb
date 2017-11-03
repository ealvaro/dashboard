class DropColumnOccurredFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :occurred, :datetime
  end
end
