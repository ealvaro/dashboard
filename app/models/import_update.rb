class ImportUpdate < ActiveRecord::Base
  belongs_to :import

  validates :description, presence: true, allow_nil: false
  validates :update_type, presence: true, allow_nil: false

  validate :update_type do
    unless update_types.include? update_type.upcase
      errors.add( :update_type, "is not valid" )
      return false
    end
    true
  end

  def update_types
    %w(WARNING ERROR FAILURE NOTE FINISHED INCOMPLETE)
  end
end
