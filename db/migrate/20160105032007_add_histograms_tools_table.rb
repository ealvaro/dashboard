class AddHistogramsToolsTable < ActiveRecord::Migration
  def change
    create_table :histograms_tools, :id => false do |t|
        t.references :histogram, index: true
        t.references :tool, index: true
    end

    remove_column :histograms, :tool_id, :integer
  end
end
