class CreateSideTracks < ActiveRecord::Migration
  def change
    create_table :side_tracks do |t|
      t.belongs_to :run, index: true
      t.integer :number
      t.float :origination_measured_depth
    end
  end
end
