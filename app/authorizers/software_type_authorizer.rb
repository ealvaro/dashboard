class SoftwareTypeAuthorizer < ApplicationAuthorizer

  def self.readable_by?(software_type)
    software_type.has_role? :admin
  end

  def self.creatable_by?(software_type)
    software_type.has_role? :admin
  end

  def self.updatable_by?(software_type)
    software_type.has_role? :admin
  end

  def self.deletable_by?(software_type)
    software_type.has_role? :admin
  end

end
