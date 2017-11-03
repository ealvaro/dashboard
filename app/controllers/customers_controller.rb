class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :set_client

  def index
    authorize_action_for Customer
    @customers = CustomerDecorator.new( @client.customers )
  end

  def show
    authorize_action_for @customer
  end

  def new
    @customer = Customer.new.decorate
    authorize_action_for @customer
  end

  def edit
    authorize_action_for @customer
  end

  def create
    @customer = @client.customers.build( customer_params ).decorate
    authorize_action_for @customer

    if @customer.save
      redirect_to client_customer_path( @client, @customer ), notice: 'Customer was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize_action_for @customer
    if @customer.update(customer_params)
      redirect_to client_customer_path( @client, @customer ), notice: 'Customer was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize_action_for @customer
    @customer.destroy
    redirect_to client_customers_url, notice: 'Customer was successfully destroyed.'
  end

  private

  def set_customer
    @customer = Customer.find(params[:id]).decorate
  end

  def set_client
    @client = Client.find( params[:client_id] )
  end

  def customer_params
    params.require( :customer).permit( valid_params )
  end

  def valid_params
    %i( id name email )
  end
end
