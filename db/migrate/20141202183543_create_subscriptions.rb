class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :job, index: true
      t.belongs_to :run, index: true
      t.text :interests
      t.timestamps
    end
  end
end
