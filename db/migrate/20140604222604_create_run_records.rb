class CreateRunRecords < ActiveRecord::Migration
  def change
    create_table :run_records do |t|
      t.integer :directional_drilling_tool_id
      t.integer :run_id
      t.boolean :assembled
      t.string  :incident
      t.string  :ci_incident
      t.text    :mwd_comment
      t.integer :mas_temperature
      t.float   :item_start_hrs
      t.float   :circulating_hrs
      t.float   :rotating_hours
      t.float   :sliding_hours
      t.float   :total_drilling_hours
      t.float   :mud_weight
      t.integer :gpm
      t.string  :bit_type
      t.float   :motor_bend
      t.integer :rpm
      t.integer :chlorides
      t.integer :sand
      t.float   :agitator
      t.date    :brt
      t.date    :art
      t.boolean :from_shop
      t.boolean :from_job

      t.timestamps
    end
  end
end
