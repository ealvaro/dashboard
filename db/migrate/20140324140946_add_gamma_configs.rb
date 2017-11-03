class AddGammaConfigs < ActiveRecord::Migration
  execute "create extension hstore"
  def change
    change_table :mandates do |t|
      t.hstore 'gv_configs', array: true
      t.references :region 
      t.hstore :thresholds
      t.hstore :logging_params
    end
  end
end
