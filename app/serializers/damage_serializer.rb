class DamageSerializer < ActiveModel::Serializer
  attributes :damage_group, :original_amount_in_cents, :amount_in_cents_as_billed, :key, :description

  def key
    object.damage_group
  end
end
