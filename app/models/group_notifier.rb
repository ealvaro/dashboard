class GroupNotifier < UpdateNotifier
  alias_attribute :group, :notifierable

  def self.find_by_rig(rig)
    return [] unless rig
    notifiers = []
    RigGroup.all.select{|rg| rg.rig_ids.include? rig.id}.each do |rig_group|
      notifiers << GroupNotifier.where(notifierable: rig_group)
    end
    notifiers.flatten
  end

  def self.find_by_group group_id
    where(notifierable_id: group_id, notifierable_type: 'RigGroup')
  end
end
