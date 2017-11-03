class RunRecordDecorator < ApplicationDecorator
  delegate_all

  def job
    object.run.job.name
  end

  def run
    object.run.number.to_s
  end

  def tool
    object.tool.serial_number
  end

  def tool_type
    object.tool.tool_type.name
  end

end
