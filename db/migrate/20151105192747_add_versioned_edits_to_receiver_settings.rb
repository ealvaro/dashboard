class AddVersionedEditsToReceiverSettings < ActiveRecord::Migration
  def change
    add_column :receiver_settings, :version_number, :integer, default: 1
    add_column :receiver_settings, :key, :integer, allow_nil: false, index: true
  end
end
