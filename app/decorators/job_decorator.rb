class JobDecorator < ApplicationDecorator
  delegate_all

  def client
    object.client.try(:name)
  end

  def rig
    object.rig.try(:name)
  end

  def well
    object.well.try(:name)
  end

end

