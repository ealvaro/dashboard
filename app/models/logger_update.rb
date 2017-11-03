class LoggerUpdate < Update
  def publish
    if newer?
      if job_id || run_id
        self.job ||= run.job
        if job && !Job.active.include?( job )
          Pusher["active-jobs"].trigger("update", {message: "Please refresh your jobs!"})
          job.touch
        end

        if job_number.present?
          self.bore_pressure = nil
          data = V744::LoggerUpdateSerializer.new(self, root: false).as_json
          Pusher["logger-#{job_number.downcase}"].trigger("update", data)
          Pusher["active-job-data"].trigger("update", data)
        end
      end
      true
    end
  end
end
