class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :roles, :settings, :errors, :portal_roles, :lconfig_roles, :updated_at, :created_at
  attributes :edit_url, :destroy_url, :follows, :templates

  # has_many :subscriptions, serializer: ShallowSubscriptionSerializer
  has_many :threshold_settings

  def portal_roles
    object.roles.reject{|r| r.downcase.include?( 'lconfig' )}
  end

  def lconfig_roles
    object.roles.select{|r| r.downcase.include?( 'lconfig' )}
  end

  def edit_url
    object.persisted? ? edit_admin_user_path(object) : nil
  end

  def destroy_url
    begin
      if object.deletable_by?( scope )
        return push_user_path(object)
      end
      return nil
    rescue
      return nil
    end
  end
end
