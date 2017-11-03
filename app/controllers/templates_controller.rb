class TemplatesController < ApplicationController
  def index
    user = User.find(params[:user_id]) if params[:user_id].present?
    user ||= current_user
    @templates = user.templates.order(updated_at: :desc)
    render json: @templates, root: false
  end

  def new
    @template = Template.new
    render json: @template, root: false
  end

  def create
    @template = Template.new template_params
    @template.user = current_user
    if @template.save
      render json: {message: 'Success'}, status: 200
    else
      render json: {message: 'Error'}, status: :bad_request
    end
  end

  def edit
    set_template
    render json: @template, root: false
  end

  def update
    set_template
    if @template.update template_params
      render json: { message: 'Success' }, status: 200
    else
      render json: { message: 'Error' }, status: 422
    end
  end

  def destroy
    set_template
    if @template.destroy
      render json: { message: 'Success' }, status: 200
    else
      render json: { message: 'Error' }, status: 422
    end
  end

  def clone
    template = Template.find params[:template_id]
    if template.clone(template_params[:name])
      render json: { message: 'Success' }, status: 200
    else
      render json: { message: 'Error' }, status: 422
    end
  end

  def import
    template = Template.find params[:template_id]
    if template.import(current_user)
      render json: { message: 'Success' }, status: 200
    else
      render json: { message: 'Error' }, status: 422
    end
  end

  private

    def template_params
      params.require(:template).permit(:name, :job_id)
    end

    def set_template
      @template = Template.find params[:id]
    end
end
