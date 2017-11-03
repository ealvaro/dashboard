class Install < ActiveRecord::Base

  validates :key, presence: true, allow_unique: false, on: :update
  validates :application_name, presence: true, allow_nil: false
  validates :version, presence: true, allow_nil: false
  validates :ip_address, presence: true, allow_nil: false
  include Authority::Abilities

  scope :recent, -> {where("updated_at >= ?", (DateTime.now - 4.weeks ).to_s(:db)).order(updated_at: :desc)}

  before_save on: :create do
    size = 8
    self.key ||= SecureRandom.hex(size)[0...size]
  end

  def self.for_key_or_create(args)
    Install.where(key: args[:key]).first_or_create(args.except(:key)).tap do |i|
      i.attributes = args.except(:key)
      if i.changed?
        i.save
      else
        i.touch if i.persisted?
      end
    end
  end
end
