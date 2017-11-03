class CreateMandates < ActiveRecord::Migration
  def change
    create_table :mandates do |t|
      t.string :type, index: true
      t.string :public_token, allow_nil: false, allow_unique: false, index: true
      t.datetime :expiration
      t.integer :occurences, default: -1, allow_nil: false
      t.string :for_tool_ids
      t.integer :priority
      t.integer :vib_trip_hi
      t.integer :vib_trip_lo
      t.integer :vib_trip_hi_a
      t.integer :vib_trip_lo_a

      t.timestamps
    end
  end
end

