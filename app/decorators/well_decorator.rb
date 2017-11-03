class WellDecorator < ApplicationDecorator
  delegate_all

  def formation
   object.formation ? object.formation.name : nil
  end
end
