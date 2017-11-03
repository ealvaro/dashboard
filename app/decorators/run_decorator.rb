class RunDecorator < ApplicationDecorator
  delegate_all

  def job
    object.job.name
  end

  def well
    object.well.try( :name )
  end

  def well_id
    object.job.try(:well).try(:id)
  end

  def rig
    object.rig.try( :name )
  end

  def rig_id
    object.job.try(:rig).try(:id)
  end

  def client
    object.job.try(:client).try(:name)
  end

  def client_id
    object.job.try(:client).try(:id)
  end

  def occurred
    object.occurred ? object.occurred.strftime( "%F %r" ) : nil
  end

end
