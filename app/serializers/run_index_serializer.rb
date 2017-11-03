class RunIndexSerializer < ActiveModel::Serializer
  attributes :id, :number, :job, :well, :rig, :occurred, :show_url, :edit_url

  def job
    object.job ? object.job.as_json : nil
  end

  def well
    object.well ? object.well.as_json : nil
  end

  def rig
    object.rig ? object.rig.as_json : nil
  end

  def show_url
    object.persisted? ? run_path( object ) : nil
  end

  def edit_url
    object.persisted? ? edit_run_path( object ) : nil
  end
end