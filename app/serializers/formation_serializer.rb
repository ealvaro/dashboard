class FormationSerializer < ActiveModel::Serializer
  attributes :name, :multiplier, :show_url, :edit_url

  def edit_url
    object.persisted? ? edit_formation_path(object) : nil
  end

  def show_url
    object.persisted? ? formation_path(object) : nil
  end
end
