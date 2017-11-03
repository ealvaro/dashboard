class RunSerializer < ShallowRunSerializer
  attributes :multiplier

  has_many :run_records, serializer: RunRecordShallowSerializer
  has_many :tools
  has_many :damages

  has_one :job, serializer: JobShallowSerializer
  has_one :well
  has_one :rig
  has_one :formation

  def job
    object.job
  end

  def well
    object.well
  end

  def rig
    object.rig
  end

  def formation
    object.well ? object.well.formation : nil
  end

  def multiplier
    object.well && object.well.formation ? object.well.formation.multiplier : 1
  end
end
