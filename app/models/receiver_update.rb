class ReceiverUpdate < Update
  def publish
    if newer?
      if (job_id || run_id) && published_at.blank?
        self.job ||= run.job

        Pusher["active-jobs"].trigger("update", {message: "Please refresh your jobs!"}) unless Job.active.include? job
        job.touch

        self.average_pulse ||= 0
        self.power ||= nil
        self.frequency ||= nil
        self.fft ||= nil
        data = V744::ReceiverUpdateSerializer.new(self, root: false).as_json

        # The pulse data is too large. Send separately
        pulse = data.slice(:pulse_data, :low_pulse_threshold)
        data.except!(:pulse_data, :low_pulse_threshold)

        Pusher["active-job-data"].trigger("update", data)

        pusher_rx = Pusher["#{receiver_type.downcase}-#{job_number.downcase}"]
        pusher_rx.trigger("update", data)

        if pulse.present?
          pusher_rx.trigger("pulse", pulse)
        end

        if data[:fft].present?
          pusher_rx.trigger("fft", data)
        end

        update_attributes published_at: DateTime.now
      end
      true
    end
  end

  def merge_tool_face_data!(source)
    if source.present?
      self.tool_face_data ||= []
      source.each do |d|
        index = self.tool_face_data.index { |dd| d["order"] == dd["order"] }
        if index.present?
          self.tool_face_data[index] = d
        else
          self.tool_face_data.push d
        end
      end
    end
  end

  def save_as_compressed(values, sample_rate, time_stamp)
    if values.present?
      default_sample_rate = (self.type == "EmReceiverUpdate" && 153.0) || 10.0
      sample_rate = sample_rate.try(:to_f) || default_sample_rate
      sample_rate = default_sample_rate if sample_rate == 0
      time_stamp = time_stamp.try(:to_i) || 0

      self.pulse_data = { "time_stamp" => time_stamp,
                          "sample_rate" => sample_rate,
                          "values" => values }
    end
  end
end
