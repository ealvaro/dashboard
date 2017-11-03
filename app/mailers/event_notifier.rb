class EventNotifier < ActionMailer::Base
  default from: ENV["FROM_EMAIL"]

  def crossover_email( event )
    perform_send event
  end

  def crossover_detected_email( event )
    perform_send event
  end

  private

  def perform_send(event)
    users = User.select{ |u| u.roles.include?( "Email Crossover Events" ) }
    users.each do |u|
      @user = u
      @event = event
      @identifier = event.tool.uid
      @primary_asset_number = event.primary_asset_number
      @url = event_url( id: event )
      mail( to: @user.email, subject: 'Crossover Event Occurance').deliver
    end
  end
end
