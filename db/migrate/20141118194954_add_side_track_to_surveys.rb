class AddSideTrackToSurveys < ActiveRecord::Migration
  def change
    add_reference :surveys, :side_track, index: true
    remove_column :surveys, :side_track, :string
  end
end
