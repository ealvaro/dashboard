class RunRecordShallowSerializer < ActiveModel::Serializer
  attributes :max_temperature, :item_start_hrs, :circulating_hrs, :rotating_hours, :sliding_hours, :total_drilling_hours, :mud_weight
  attributes :gpm, :bit_type, :motor_bend, :rpm, :chlorides, :sand, :brt, :art, :created_at, :updated_at, :import_id, :bha, :agitator_distance
  attributes :mud_type, :agitator, :max_shock, :max_vibe, :shock_warnings

  has_one :tool
end
