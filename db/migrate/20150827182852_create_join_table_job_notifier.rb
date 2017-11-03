class CreateJoinTableJobNotifier < ActiveRecord::Migration
  def change
    create_join_table :jobs, :notifiers do |t|
      t.index [:job_id, :notifier_id]
      t.index [:notifier_id, :job_id]
    end
  end
end
