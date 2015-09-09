class User < ActiveRecord::Base
  has_many :tweets

def twitter_client
	$twitter = Twitter::REST::Client.new do |config|
	config.consumer_key = ENV["CUSTOMER_KEY"]
	config.consumer_secret = ENV["CUSTOMER_SECRET"]
	config.access_token = self.token
	config.access_token_secret = self.token_secret
  end
  $twitter
end


end


