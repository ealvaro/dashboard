class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_valid_params

  def new
    @client = Client.new
    authorize_action_for @client
  end

  def edit
    @client = Client.find( params[:id] )
    authorize_action_for @client
  end

  def index
    authorize_action_for Client
    @clients = Client.visible.order(name: :asc).page params[:page]
  end

  def show
    @client = Client.find( params[:id] )
    authorize_action_for @client
  end

  def update
    @client = Client.find( params[:id] )
    authorize_action_for @client
    if @client.update_attributes( client_params )
      redirect_to client_path( @client ), notice: Client.model_name.human + " successfully updated."
    else
      render :edit
    end
  end

  def create
    @client = Client.new( client_params )
    authorize_action_for @client
    if @client.save
      redirect_to client_path( @client ), notice: Client.model_name.human + " successfully created."
    else
      render :new
    end
  end

  def search
    keywords = params[:keywords]
    @clients = Client.search(keywords).page params[:page]
    render :index
  end

  def ignore
    @client = Client.find(params[:id])
    @client.update(hidden: true)

    redirect_to clients_path, notice: "Client '#{@client.name}' Ignored"
  end

  authority_actions :ignore=>'update'

  private

  def client_params
    params.require( :client ).permit( @valid_params )
  end

  def set_valid_params
    @valid_params = %i( id name address_street address_city address_state zip_code country )
  end
end
