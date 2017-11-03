class SearchesController < ApplicationController
  def index
    @keywords = params[:keywords].delete(':').strip

    unless @keywords.blank?
      @page = params[:page]
      search_all
    end
  end

  protected

  def search_all
    search_by_keywords
    search_by_jobs
    search_by_custom

    @wells = ilike_search_for Well
    @formations = ilike_search_for Formation
  end

  def search_by_keywords
    @tools = regular_search_for Tool
    @jobs = regular_search_for Job
    @tool_types = regular_search_for ToolType
    @clients = regular_search_for Client
    @alerts = regular_search_for Notification
  end

  def search_by_jobs
    @runs = jobs_search_for Run
    @report_requests = jobs_search_for ReportRequest.active
    @surveys = jobs_search_for Survey.visible.where(version_number: 1)
  end

  def search_by_custom
    @events = order_page(Event.search(@keywords).not_config, {time: :desc})
    @installs = order_page(Install.where(job_number: @jobs.pluck(:name)))
    @software = order_page(Software.search(@keywords), {version: :desc})
  end

  def regular_search_for(model)
    search(model, @keywords)
  end

  def jobs_search_for(model)
    search(model, @jobs)
  end

  def ilike_search_for(model)
    order_page model.where("name ilike ?", "%#{@keywords}%")
  end

  def search(model, keywords)
    order_page model.search(keywords)
  end

  def order_page(model, order = {updated_at: :desc})
    model.order(order).page(@page)
  end
end
