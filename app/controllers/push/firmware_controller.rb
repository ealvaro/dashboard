class Push::FirmwareController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    ActiveSupport::JSON::Encoding.escape_html_entities_in_json = false
    @firmware_updates = FirmwareUpdate.all.sort_by{|u| [u.tool_type, OrderedVersion.new(u.version)] }
    respond_with @firmware_updates, each_serializer: FirmwareUpdateSerializer, meta: {curated_at: Time.now.utc.to_i}
  end
end
