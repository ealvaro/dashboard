class AddNotifierableToNotifiers < ActiveRecord::Migration
  def change
    add_reference :notifiers, :notifierable, index: true, polymorphic: true
  end
end
