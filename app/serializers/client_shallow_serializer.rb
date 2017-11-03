class ClientShallowSerializer < ActiveModel::Serializer
  attributes :id, :name, :show_url, :edit_url, :pricing, :address_street, :address_city, :address_state, :zip_code, :country

  def edit_url
    object.persisted? ? edit_client_path(object) : nil
  end

  def show_url
    client_path( object )
  end
end