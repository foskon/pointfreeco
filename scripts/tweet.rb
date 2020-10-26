require 'twitter'
require_relative 'credentials'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = $consumer_key
  config.consumer_secret     = $consumer_secret
  config.access_token        = $access_token
  config.access_token_secret = $access_token_secret
end

tweet = ARGV[0]
puts "Tweeting:\n\t" + tweet
client.update(tweet)