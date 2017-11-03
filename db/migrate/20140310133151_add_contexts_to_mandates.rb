class AddContextsToMandates < ActiveRecord::Migration
  def change
    change_table :mandates do |t|
      t.string :contexts, array: true
    end
  end
end
