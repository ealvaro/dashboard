class AddRecentUpdatesToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :cache,
                      :json,
                      default: { recent_updates: { BtrReceiverUpdate: [],
                                                   LeamReceiverUpdate: [],
                                                   LoggerUpdate: [] }
                               }
  end
end
