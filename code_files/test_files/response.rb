require 'uri'
require 'net/http'
url = "http://localhost:2000"
r = Net::HTTP.get_response(URI.parse(url))
