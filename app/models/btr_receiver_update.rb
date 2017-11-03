class BtrReceiverUpdate < ReceiverUpdate
  after_save :cache_pump_time

  def receiver_type
    "btr-receiver"
  end
end