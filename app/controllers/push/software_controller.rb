class Push::SoftwareController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    ActiveSupport::JSON::Encoding.escape_html_entities_in_json = false
    @software = Software.all.sort_by{|u| [u.name, OrderedVersion.new(u.version)] }.reverse
    respond_with @software, each_serializer: SoftwareSerializer, meta: {curated_at: Time.now.utc.to_i}
  end
end
