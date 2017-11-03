# usage:
# rails c
# load "~/dev/tracker-wolf2/scripts/patch_event_uid.rb"

require 'aws-sdk-core'

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(ENV["AWS_KEY_ID"],
                                    ENV["AWS_SECRET_KEY"])
})

target_bucket = ENV["AWS_BUCKET"]

s3 = Aws::S3::Resource.new
bucket = s3.bucket(target_bucket)
puts "Targeting #{bucket.name}"

total_count = 0
present_count = 0
not_found = 0

s3 = Aws::S3::Client.new
s3.list_objects(bucket: target_bucket).each do |response|
  response.contents.each do |object|
    total_count += 1
    record = object.key.split('/')
    if record[0] == "uploads" and record[1] == "tool_events"
      if record[2].present? and record[3].present? and record[4].present? and
        present_count += 1
        filename = record[4]
        uid = record[3]

        model = EventAsset.where('lower(file) = ?', filename.downcase).first
        if model
          model.uid = uid
          model.save
        else
          not_found += 1
        end
      end
    end
  end
end

puts "Results", "-------"
puts "total_count: #{total_count}"
puts "present_count: #{present_count}"
puts "match count: #{present_count - not_found}"
puts "not_found: #{not_found}"
