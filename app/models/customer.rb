class Customer < ActiveRecord::Base
  include Authority::Abilities

  belongs_to :client
  validates :email, presence: true, allow_nil: false, uniqueness: {scope: :email}
  #has_many :invoices, through: :runs
  #has_many :jobs, through: :client
  #has_many :runs, through: :jobs

  validates_presence_of :client, :name
end
