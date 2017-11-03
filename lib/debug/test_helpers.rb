module TestHelpers
  def call_api(url, json)
    Thread.new do
      HTTP.with_headers(:accept => 'application/json', "X-Auth-Token" => ENV["auth_token"]).post( url, json: json)
      ActiveRecord::Base.connection.close
    end
  end
end
