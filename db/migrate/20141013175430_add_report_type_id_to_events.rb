class AddReportTypeIdToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :report_type, index: true
  end
end
