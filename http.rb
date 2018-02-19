require 'json'
require "open-uri"

params = JSON.parse(STDIN.read)
max_tries = params["max_tries"].to_i
interval = params["interval"].to_i
uri = URI(params["uri"])
filename = File.join Dir.pwd, "download"

tries = 0
begin
  File.open(filename, "wb") do |f|
    IO.copy_stream(open(uri.to_s, "rb"), f)
  end
rescue Exception => ex
  tries = tries + 1
  if max_tries == tries
    STDERR.puts "max_tries (#{max_tries}) reached for #{uri} to be success"
    exit 1
  end

  sleep interval
  retry
end

result = {
  path: filename
}

puts result.to_json
