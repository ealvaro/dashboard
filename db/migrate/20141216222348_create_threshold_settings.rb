class CreateThresholdSettings < ActiveRecord::Migration
  def change
    create_table :threshold_settings do |t|
      t.string :name
      t.belongs_to :user, index: true
      t.float :pump_off_time_in_milliseconds
      t.float :max_temperature
      t.float :max_batv
      t.float :min_batv
      t.boolean :batw
      t.boolean :dipw
      t.boolean :gravw
      t.boolean :magw
      t.boolean :tempw
      t.float :min_confidence_level
    end
  end
end
