class ClientSerializer < ClientShallowSerializer
  #attributes :new_customer, :new_job
  has_many :jobs
  has_many :customers

  def new_customer
    object.persisted? ? new_client_customer_path(object) : nil
  end

  def new_job
    object.persisted? ? new_client_job_path(object) : nil
  end
end
