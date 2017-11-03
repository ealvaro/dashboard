class CreateReportRequestAsset < ActiveRecord::Migration
  def change
    create_table :report_request_assets do |t|
      t.belongs_to :report_request, index: true
      t.string :file
      t.string :name
      t.timestamps
    end
  end
end
