class User < ActiveRecord::Base
  has_many :tweets

  def tweet(content)
    tweet = tweets.create!(:content => content)
    TweetWorker.perform_async(tweet.id)
  end

  def tweet_later(time,content)
  	post_time = time.to_i
  	tweet = tweets.create!(:content => content)
  	TweetWorker.perform_at(post_time.minutes.from_now,tweet.id)
  end

  def twitter_client
	$twitter = Twitter::REST::Client.new do |config|
	config.consumer_key = API_KEYS["TWITTER_CONSUMER_KEY"]
	config.consumer_secret = API_KEYS["TWITTER_CONSUMER_SECRET"]
	config.access_token = self.token
	config.access_token_secret = self.token_secret
    end
    $twitter
  end

  # def recent_tweets
  # 	@client = self.twitter_client
  # 	@user_feed = @client.user_timeline
  # 	@recent_tweets = @user_feed.take(10)
  # 	@recent_tweets.each do |tweet|
  # 	  @tweets = Tweet.find_or_create_by(user_id: self.id, content: tweet.text)
  # 	  self.tweets << @tweets
  # 	end
  # end

  def tweets_stale?
    @user_tweets = self.tweets
    if (Time.now - @user_tweets.first.created_at)/60 >= 1
  	  return true
    else
  	  return false
    end
  end


end


