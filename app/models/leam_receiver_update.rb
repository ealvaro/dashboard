class LeamReceiverUpdate < ReceiverUpdate
  after_save :cache_pump_time

  def receiver_type
    "leam-receiver"
  end
end