class User < ActiveRecord::Base
  has_many :tweets

  #   def fetch_tweets
  # 	@user_feed = $twitter.user_timeline(self.twitter_handle)
  # 	@new_tweet = Tweet.find_or_create_by(text: )
  # 	@updated_tweet = @user_feed.take(1)
  # 	end
  # end

end
