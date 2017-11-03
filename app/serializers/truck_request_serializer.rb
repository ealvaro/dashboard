class TruckRequestSerializer < ActiveModel::Serializer
  attributes :id, :priority, :created_at, :region_name, :job_number, :motors,
             :mwd_tools, :surface_equipment, :backhaul, :user_email,
             :computer_identifier, :notes, :status_list

  def priority
    object.priority.try(:capitalize)
  end

  def status_list
    object.status_list
  end

  def job_number
    object.job.try(:name).try(:upcase)
  end

  def region_name
    object.region.try(:name)
  end
end