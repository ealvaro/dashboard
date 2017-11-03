RigNotifier.where(notifierable_id: nil).each do |obj|
  obj.notifierable = Rig.find_by id:obj.associated_data.try(:[], "rig").try(:[],"id")
  obj.save!
end
GroupNotifier.where(notifierable_id: nil).each do |obj|
  obj.notifierable = RigGroup.find_by id:obj.associated_data.try(:[], "rigGroup").try(:[],"id")
  obj.save!
end
