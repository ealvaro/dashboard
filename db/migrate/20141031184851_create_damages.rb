class CreateDamages < ActiveRecord::Migration
  def change
    create_table :damages do |t|
      t.belongs_to :run
      t.string  :damage_group
      t.integer :original_amount_in_cents
      t.integer :amount_in_cents_as_billed
      t.string  :description
      t.timestamps
    end
  end
end
