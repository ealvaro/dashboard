class V750::ClientsController < Push::ClientsController
  def index
    @clients = Client.visible.order(name: :asc)
    render json: @clients, root: false, each_serializer: ClientShallowSerializer
  end

  def show
    @client = Client.find( params[:id] )
    if @client
      render json: @client, root: false, serializer: ClientShallowSerializer
    else
      render json: "Not Found"
    end
  end

  def destroy
    @client = Client.find( params[:id] )
    if @client
      @client.destroy
      render json: "Successfully Deleted"
    else
      render json: "Not Found"
    end
  end

  def update
    @client = Client.find( params[:id] )
    if @client.update_attributes( client_params )
      render json: "Successfully Updated"
    else
      render json: "Not Updated"
    end
  end

  def create
    @client = Client.new( client_params )
    if @client.save
      render json: "Successfully Created"
    else
      render json: "Not Created"
    end
  end

  private

  def client_params
    set_valid_params
    params.require( :client ).permit( @valid_params )
  end

  def set_valid_params
    @valid_params = %i( id name address_street address_city address_state zip_code country )
  end
end
