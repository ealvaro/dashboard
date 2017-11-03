class RunRecordsController < ApplicationController
  def index
    @tool = Tool.find( params[:tool_id] ) if params[:tool_id]
    @run = Run.find( params[:run_id] ) if params[:run_id]
    @run_records = @run ? @run.run_records : @tool.run_records
    @json = ActiveModel::ArraySerializer.new(@run_records, each_serializer: RunRecordSerializer).to_json
    @run_records = @run_records.decorate
    authorize_action_for RunRecord
  end

  def show
    @run_record = RunRecord.find( params[:id] ).decorate
    authorize_action_for @run_record
    @tool = @run_record.tool
  end
end
