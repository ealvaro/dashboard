class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.references :run
      t.references :job
      t.integer :version_number, default: 1
      t.references :user
      t.string :key, allow_nil: false, index: true
      t.boolean :hidden, default: false
      t.references :survey_import_run
      t.string :side_track, allow_nil: false
      t.decimal :measured_depth_in_feet, allow_nil: false
      t.decimal :gx, allow_nil: false
      t.decimal :gy, allow_nil: false
      t.decimal :gz, allow_nil: false
      t.decimal :g_total, allow_nil: false
      t.decimal :hx, allow_nil: false
      t.decimal :hy, allow_nil: false
      t.decimal :hz, allow_nil: false
      t.decimal :h_total, allow_nil: false
      t.string :inclination
      t.string :azimuth
      t.string :dip_angle
      t.string :north
      t.string :east
      t.string :tvd

      t.timestamps
    end
  end
end
