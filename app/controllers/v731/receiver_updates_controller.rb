class V731::ReceiverUpdatesController < V730::ReceiverUpdatesController
  # Allows uid
  def param_list
    super + [:uid]
  end
end
