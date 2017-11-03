class WellSerializer < ActiveModel::Serializer
  attributes :id, :name, :show_url, :edit_url
  has_one :formation

  def show_url
    well_path( object )
  end

  def edit_url
    edit_well_path( object )
  end
end
