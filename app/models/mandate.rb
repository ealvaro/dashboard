require 'securerandom'

class Mandate < ActiveRecord::Base
  include Authority::Abilities

  validate :occurences, inclusion: {in: [-1, 1]}, allow_nil: false
  validate :public_token, presence: true, allow_unique: false
  validate :type, presence: true, allow_nil: false

  validate :for_tool_ids do |mandate|
    mandate.errors.add(:for_tool_ids, "Must have a tool ID") if mandate.for_tool_ids.blank?
  end

  validate :contexts do |model|
    if model.contexts.blank?
      model.errors.add(:contexts, "at least one context required")
    end
  end

  before_save on: :create do
    size = 8
    self.public_token ||= SecureRandom.hex(size)[0...size]
  end

  scope :active, ->{ all }

  def self.all_mandate_types
    [DualGammaMandate, PulserMandate, SensorInterfaceMandate, DualGammaLiteMandate]
  end

  def self.by_public_token token
    find_by public_token: token
  end

  def regions
    self["regions"] || []
  end

  def regions=( value )
    write_attribute( :regions, value.delete_if(&:blank?) )
  end

  def self.tool_type_klass
    new.tool_type_klass
  end

  def self.valid_attributes
    %i(occurences for_tool_ids priority expiration optional name) + [{contexts: []}] + [{regions: []}]
  end

  def apply_unique_params(params)
    raise NotImplementedError
  end

  def contexts
    self["contexts"] || []
  end

  def contexts=( value )
    write_attribute( :contexts, value.delete_if(&:blank?) )
  end

  def for_tool_ids
    (self["for_tool_ids"] || "").split(",").map(&:strip)
  end

  def receipts
    Receipt.for_token(public_token)
  end

end
