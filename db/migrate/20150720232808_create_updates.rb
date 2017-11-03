class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :type
      t.datetime :time
      t.string :job_number
      t.belongs_to :job, index: true
      t.string :software_installation_id
      t.string :run_number
      t.belongs_to :run, index: true
      t.string :client_name
      t.belongs_to :client, index: true
      t.string :rig_name
      t.belongs_to :rig, index: true
      t.string :well_name
      t.string :string
      t.belongs_to :well, index: true
      t.string :team_viewer_id
      t.string :string
      t.string :team_viewer_password
      t.float :block_height
      t.float :hookload
      t.float :pump_pressure
      t.float :bit_depth
      t.float :weight_on_bit
      t.float :rotary_rpm
      t.float :rop
      t.float :voltage
      t.float :inc
      t.float :azm
      t.float :api
      t.float :hole_depth
      t.float :gravity
      t.float :dipa
      t.string :survey_md
      t.string :float
      t.float :survey_tvd
      t.float :survey_vs
      t.float :temperature
      t.string :com3
      t.string :com6
      t.boolean :pumps_on
      t.boolean :on_bottom
      t.boolean :slips_out
      t.boolean :livelog
      t.float :dao
      t.string :reporter_version
      t.string :decode_percentage
      t.integer :pump_on_time
      t.integer :pump_off_time
      t.integer :pump_total_time
      t.float :gravity
      t.float :magf
      t.float :gama
      t.float :atfa
      t.float :gtfa
      t.float :mtfa
      t.float :mx
      t.float :my
      t.float :mz
      t.float :ax
      t.float :ay
      t.float :az
      t.float :batv
      t.boolean :batw
      t.boolean :dipw
      t.boolean :gravw
      t.float :gv0
      t.float :gv1
      t.float :gv2
      t.float :gv3
      t.float :gv4
      t.float :gv5
      t.float :gv6
      t.float :gv7
      t.boolean :magw
      t.boolean :tempw
      t.string :sync_marker
      t.integer :survey_sequence
      t.integer :logging_sequence
      t.float :confidence_level
      t.string :average_quality
      t.string :pump_state
      t.float :tf
      t.json :pulse_data
      t.json :table
      t.json :tool_face_data
      t.timestamps
    end
  end
end
