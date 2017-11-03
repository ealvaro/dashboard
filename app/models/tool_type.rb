class ToolType < ActiveRecord::Base
  include SearchesHelper
  include PgSearch
  # multisearchable :against => [:number, :klass, :name, :description]
  has_many :tools, :dependent => :destroy
  has_many :events, through: :tools

  validates :description, uniqueness: { scope: :name }, allow_nil: false

  scope :erdos_miller, -> { where( "number is not null" ) }

  def self.search keywords
    if keywords.present?
      where("klass ilike :k OR
      name ilike :k OR
      description ilike :k", k: "%#{keywords}%")
    end
  end

  def self.for_mandate(klass)
    model = find_by(klass: klass)
    Struct.new(:id, :name).new(model.number, model.name)
  end

end