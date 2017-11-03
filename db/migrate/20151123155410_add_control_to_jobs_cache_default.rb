class AddControlToJobsCacheDefault < ActiveRecord::Migration
  def up
    change_column_default :jobs, :cache,
                          { recent_updates: { BtrReceiverUpdate: [],
                                              LeamReceiverUpdate: [],
                                              EmReceiverUpdate: [],
                                              BtrControlUpdate: [],
                                              LoggerUpdate: [] }
                          }
  end
  def down
    change_column_default :jobs, :cache,
                          { recent_updates: { BtrReceiverUpdate: [],
                                              LeamReceiverUpdate: [],
                                              EmReceiverUpdate: [],
                                              LoggerUpdate: [] }
                          }
  end
end
