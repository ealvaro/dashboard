class ShallowRunRecordSerializer < ActiveModel::Serializer
  attributes :id, :tool_id, :run_id, :max_temperature, :item_start_hrs, :circulating_hrs
  attributes :rotating_hours, :sliding_hours, :total_drilling_hours, :mud_weight, :gpm, :bit_type, :motor_bend, :rpm
  attributes :chlorides, :sand, :brt, :art, :created_at, :updated_at, :import_id, :bha, :agitator_distance, :mud_type
  attributes :agitator, :max_shock, :max_vibe, :shock_warnings
end