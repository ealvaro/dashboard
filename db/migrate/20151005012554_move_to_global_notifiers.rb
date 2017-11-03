class MoveToGlobalNotifiers < ActiveRecord::Migration
  def up
    UpdateNotifier.where(association_type: 0).update_all(type: GlobalNotifier)
  end
  def down
    UpdateNotifier.where(association_type: 0).update_all(type: UpdateNotifier)
  end
end
