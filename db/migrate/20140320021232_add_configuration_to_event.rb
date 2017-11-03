class AddConfigurationToEvent < ActiveRecord::Migration
  def change
    add_column :events, :configs, :json
  end
end
