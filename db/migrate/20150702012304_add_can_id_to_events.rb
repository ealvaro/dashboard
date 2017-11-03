class AddCanIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :can_id, :string
  end
end
