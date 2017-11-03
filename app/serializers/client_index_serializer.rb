class ClientIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :edit_url, :pricing
  #attributes :new_customer, :new_job

  has_many :jobs, serializer: JobShallowSerializer

  def edit_url
    edit_client_path(object)
  end

  def new_customer
    new_client_customer_path(object)
  end

  def new_job
    new_client_job_path(object)
  end
end