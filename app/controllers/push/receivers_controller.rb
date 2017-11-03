class Push::ReceiversController < ApplicationController
  include TokenAuthenticating
  before_action :authenticate_request, except: [:test]
  respond_to :json

  def create
    if(params[:uid])
      @receiver = Tool.find_by(uid: params[:uid])
      @receiver ||= ToolType.find_by( number: 4 ).tools.create! uid: params[:uid]
    else
      @receiver ||= ToolType.find_by( number: 4 ).tools.create!
    end
    render json: @receiver, root: false
  end

  def events
    @receiver = Tool.find_by(uid: params[:id])
    if @receiver
      @receiver.touch
      Pusher["receiver"].trigger("update", params[:data].merge(uid: @receiver.uid, updated_at: DateTime.now.utc.to_s))
      @receiver.alert!(params[:data])
      render json: { message: "Events sent" }
    else
      render json: { message: "Unknown receiver"}
    end
  end

  def index
    render json: ToolType.find_by(number: '4').tools.order(updated_at: :desc), root: false
  end

  def test
    @receiver = Tool.find_by(uid: params[:id])
    TestReceiver.new(@receiver).publish_events
    render json: { message: "Test events sent" }
  end
end
