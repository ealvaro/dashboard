class NotifiersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notifier, only: [:show, :edit, :update]
  before_action do
    authorize_action_for Notifier
  end

  authority_actions updates_fields: 'read'

  def show
  end

  def new
    @notifier_json = {}.to_json
  end

  def create
    render json: {message: 'Cannot create generic notifier'}, status: :bad_request
  end

  def edit
    @notifier_json = UpdateNotifier.find(params[:id]).to_json
  end

  def update
    @notifier = UpdateNotifier.find params[:id]
    @notifier.assign_attributes notifier_params

    all_done = false
    if @notifier.valid?
      notifier_dup = @notifier.dup
      all_done = notifier_dup.save

      # retire the old notifier and keep around
      # in case of notification associations
      @notifier.hidden = true
      @notifier.save
    end

    if all_done
      render json: {message: 'ok'}
    else
      render json: {message: 'error'}, status: :bad_request
    end
  end

  def destroy
    @notifier = UpdateNotifier.find params[:id]
    @notifier.hidden = true
    @notifier.save

    render json: {message: 'ok'}
  end

  def updates_fields
    fields = (Update.column_names + UpdateNotifier.meta_list - UpdateNotifier.black_list)
    logger = fields - UpdateNotifier.not_logger
    rx = fields - UpdateNotifier.not_rx

    render json: {"logger" => make_update_fields(logger),
                  "receiver" => make_update_fields(rx)}
  end

  def make_update_fields(fields)
    out = []
    fields.sort.each { |f| out << {"name" => Update.human_attribute_name(f), "value" => f} }
    out
  end

  private
    def set_notifier
      @notifier = UpdateNotifier.find(params[:id])
    end

    def notifier_params
      params.require(:notifier).permit(:name).tap do |whitelisted|
        whitelisted[:configuration] = params[:notifier][:configuration]
        whitelisted[:associated_data] = params[:notifier][:associated_data]
      end
    end
end
