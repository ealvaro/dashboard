class MandatesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_klass!, only: [:new, :create]
  before_action :remove_empty_string_contexts

  def index
    @mandates = Mandate.all.order("created_at DESC")
  end

  def new
    @mandate = @klass.new
  end

  def receipts
    @mandate = Mandate.find(params[:id])
    @receipts = @mandate.receipts
  end

  def create
    @mandate = @klass.new
    @mandate.apply_unique_params(params[:mandate])
    @klass= @mandate.class
    @mandate.attributes = mandate_params
    if @mandate.save
      redirect_to mandates_path, notice: "Mandate Created"
    else
      render :new
    end
  end

  def update
    @mandate = Mandate.find(params[:id])
    @mandate.apply_unique_params(params[:mandate])
    @klass= @mandate.class
    if @mandate.update_attributes mandate_params
      redirect_to mandates_path, notice: "Mandate Updated"
    else
      render :edit
    end
  end

  def edit
    @mandate = Mandate.find(params[:id])
    @klass = @mandate.class.to_s
  end

  def destroy
    Mandate.destroy params[:id]
    redirect_to mandates_path
  end

  private
  def mandate_params
    params.require(:mandate).permit(@klass.valid_attributes)
  end

  def set_klass!
    @klass = Mandate.all_mandate_types.find{|k| k.to_s == params[:klass]}
  end

  def remove_empty_string_contexts
    params[:mandate][:contexts].delete_if(&:empty?) if params[:mandate] && params[:mandate][:contexts]
  end
end
