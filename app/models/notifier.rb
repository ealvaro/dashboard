class Notifier < ActiveRecord::Base
  include Authority::Abilities
  include Notifiers::HumanReadable
  include Notifiers::Configurable
  include Notifiers::FieldTypes

  after_initialize :raise_initialization_error

  has_many :notifications
  belongs_to :notifierable, polymorphic: true

  validates :name, presence: true
  validates :configuration, presence: true

  scope :visible, -> { where("hidden != true") }

  private
    def raise_initialization_error
      if self.class.name == 'Notifier'
        raise 'You cannot initialize a generic Notifier'
      end
    end
end
