require 'json'
require 'net/http'
require 'tempfile'

params = JSON.parse(STDIN.read)
max_tries = params["max_tries"].to_i
interval = params["interval"].to_i
uri = URI(params["uri"])
file = File.join Dir.pwd, "download"

tries = 0
loop do
  tries = tries + 1

  response = Net::HTTP.get_response(uri)

  if response.kind_of? Net::HTTPSuccess
    file = File.new file, "wb"
    file.write(response.body)
    file.close

    result = {
      path: file.path
    }

    puts result.to_json
    exit 0
  end

  if max_tries == tries
    STDERR.puts "max_tries (#{max_tries}) reached for #{uri} to be success"
    exit 1
  end

  sleep interval
end
