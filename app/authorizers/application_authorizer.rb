# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer

  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(adjective, user)
    # 'Whitelist' strategy for security: anything not explicitly allowed is
    # considered forbidden.
    false
  end

  def self.authorizes_to_update_password?(user, options={})
    return true if options[:user].id == user.id
    if options[:user].has_role?( :admin )
      false
    else
      user.has_role? :admin
    end
  end

  def self.authorizes_to_view_debug?(user)
    user.has_role? :admin
  end
end
