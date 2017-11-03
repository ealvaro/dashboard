class CreatePricingSchemes < ActiveRecord::Migration
  def change
    create_table :default_pricing_schemes do |t|
      t.json   :max_temperature
      t.json   :max_shock
      t.json   :max_vibe
      t.json   :shock_warnings
      t.json   :motor_bend
      t.json   :rpm
      t.json   :agitator_distance
      t.json   :mud_type
      t.json   :dd_hours
      t.json   :mwd_hours
      t.belongs_to :client
      t.string :type
      t.timestamps
    end
  end
end
