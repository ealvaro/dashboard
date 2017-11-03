class InstallDecorator < ApplicationDecorator
  delegate_all

  def reporter_context
    return nil unless object.reporter_context
    if object.reporter_context.include?( "Debug" )
      "Debug"
    elsif object.reporter_context.include?( "Admin" )
      "Admin"
    elsif object.reporter_context.include?( "Service" )
      "Service"
    elsif object.reporter_context.include?( "Field" )
      "Field"
    else
      nil
    end
  end
end
