class JobAuthorizer < BillingAuthorizer

  def self.readable_by?(user)
    super || user.has_role?( :"client-info" )
  end

  def self.creatable_by?(user)
    super || user.has_role?( :"client-info" )
  end

  def self.updatable_by?(user)
    super || user.has_role?( :"client-info" )
  end

  def self.deletable_by?(user)
    user.has_role? :superuser
  end
end
