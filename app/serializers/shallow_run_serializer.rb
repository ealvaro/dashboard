class ShallowRunSerializer < ActiveModel::Serializer
  attributes :id, :number, :created_at, :updated_at, :show_url, :edit_url, :invoice_id
  attributes :max_temperature_as_billed, :item_start_hrs_as_billed, :circulating_hrs_as_billed, :rotating_hours_as_billed,
             :sliding_hours_as_billed, :total_drilling_hours_as_billed, :mud_weight_as_billed, :gpm_as_billed,
             :bit_type_as_billed, :motor_bend_as_billed, :rpm_as_billed, :chlorides_as_billed, :sand_as_billed, :brt_as_billed,
             :art_as_billed, :bha_as_billed, :agitator_distance_as_billed, :mud_type_as_billed, :agitator_as_billed, :dd_hours_as_billed,
             :max_shock_as_billed, :max_vibe_as_billed, :shock_warnings_as_billed, :damages_as_billed, :occurred

  def show_url
    run_path( object )
  end

  def edit_url
    edit_run_path( object )
  end
end
