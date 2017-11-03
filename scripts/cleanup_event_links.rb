Client.destroy_all && Job.destroy_all && Run.destroy_all && RunRecord.destroy_all && Rig.destroy_all && Well.destroy_all
Event.all.find_each(batch_size: 200) do |e|
  e.update_attributes run_id: nil
  puts e.id.to_s + "*********************************************************"
end
