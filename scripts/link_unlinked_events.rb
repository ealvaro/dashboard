Event.where("run_id is null and run_number is not null and job_number is not null").find_each(batch_size: 200) do |e|
  e.save
end
