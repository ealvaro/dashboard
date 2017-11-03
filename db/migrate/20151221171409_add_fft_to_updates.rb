class AddFftToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :fft, :json
  end
end
