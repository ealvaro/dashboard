class CreateReportRequestType < ActiveRecord::Migration
  def change
    create_table :report_request_types do |t|
      t.string :name
      t.string :scaling

      t.timestamps
    end

    create_table :report_request_types_requests, id: false do |t|
      t.belongs_to :report_request, index: true
      t.belongs_to :report_request_type, index: true
    end
  end
end
