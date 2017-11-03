class ImportDecorator < ApplicationDecorator
  delegate_all

  def started_at
    tmp = object.last_run_at
    tmp ? tmp.strftime( "%F %r" ) : nil
  end

  def ended_at
    tmp = object.import_updates.where( update_type: "FINISHED" ).last
    tmp.nil? ? nil : tmp.created_at.strftime( "%F %r" )
  end

  def user
    object.user.name
  end
end
