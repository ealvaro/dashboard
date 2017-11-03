class CreateSurveyImportRuns < ActiveRecord::Migration
  def change
    create_table :survey_import_runs do |t|

      t.timestamps
    end
  end
end
