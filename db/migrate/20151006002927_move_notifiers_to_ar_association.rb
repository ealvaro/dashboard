class MoveNotifiersToArAssociation < ActiveRecord::Migration
  def up
    Notifier.where(association_type: 0).each do |obj|
      obj.type = "GlobalNotifier"
      obj.save!
    end
    Notifier.where(association_type: 3).each do |obj|
      obj.type = "RigNotifier"
      obj.notifierable = Rig.find_by id:obj.associated_data.try(:[], "rig").try(:[],"id")
      obj.save!
    end
  end

  def down
    Notifier.where(association_type: [0,3]).each do |obj|
      obj.type = "UpdateNotifier"
      obj.notifierable = nil
      obj.save!
    end
  end
end
