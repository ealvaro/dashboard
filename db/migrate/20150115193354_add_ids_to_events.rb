class AddIdsToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :job, index: true
    add_reference :events, :well, index: true
    add_reference :events, :rig, index: true
    add_reference :events, :client, index: true
    add_reference :events, :region, index: true
  end
end
