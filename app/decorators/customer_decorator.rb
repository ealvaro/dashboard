class CustomerDecorator < ApplicationDecorator
  delegate_all

  def client
    object.client.name
  end

end
