module HasRemoteOpsUpdates
  extend ActiveSupport::Concern

  included do
    #generic updates
    has_many :updates
    has_many :receiver_updates

    #specific upates
    has_many :logger_updates
    has_many :btr_receiver_updates
    has_many :leam_receiver_updates
  end
end