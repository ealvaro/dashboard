class InvoiceSerializer < InvoiceShallowSerializer
  #consider dropping client and job name
  attributes :id, :number, :mud_types, :client_name, :job_name, :index_url, :show_url, :edit_url, :destroy_url, :errors
  attributes :client, :job
  attributes :updated_at, :status, :run_numbers, :date_of_issue
  attributes :multiplier_as_billed, :discount_percent_as_billed, :total

  has_many :runs
  has_one :job

  def run_numbers
    object.persisted? && !object.runs.empty? ? object.runs.map(&:number).join(",") : nil
  end

  def client
    object.persisted? && !object.runs.empty? ? ClientShallowSerializer.new(object.runs.first.job.client, root: false).as_json : nil
  end

  def job
    object.persisted? && !object.runs.empty? ? object.runs.first.job : nil
  end

  def client_name
    object.persisted? && !object.runs.empty? ? object.runs.first.job.client.name : nil
  end

  def job_name
    object.persisted? && !object.runs.empty? ? object.runs.first.job.name : nil
  end

  def index_url
    invoices_path
  end

  def show_url
    object.persisted? ? invoice_path(object) : nil
  end

  def edit_url
    object.persisted? ? edit_invoice_path(object) : nil
  end

  def destroy_url
    object.persisted? && object.status == "draft" ? push_invoice_path(object) : nil
  end
end
