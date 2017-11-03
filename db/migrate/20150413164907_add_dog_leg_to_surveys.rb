class AddDogLegToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :horizontal_section, :float
    add_column :surveys, :dog_leg_severity, :float
  end
end
