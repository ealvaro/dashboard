class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_event, only: [:show]
  def show
    @event_json = EventSerializer.new( @event, root: false ).to_json
  end

  private

  def find_event
    @event = Event.find( params[:id] )
  end
end
