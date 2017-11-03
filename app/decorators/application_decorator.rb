class ApplicationDecorator < Draper::Decorator

  def created_at
    object.created_at.strftime( "%F %r" )
  end

  def updated_at
    object.updated_at.strftime( "%F %r" )
  end

end

