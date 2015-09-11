class TweetWorker
  include Sidekiq::Worker
  
  def perform(tweet_id)
  tweet = Tweet.find(tweet_id)
  user = tweet.user
    @client = user.twitter_client
    @client.update(tweet.content)
  end

  def self.job_is_complete(jid)
  waiting = Sidekiq::Queue.new
  working = Sidekiq::Workers.new
  pending = Sidekiq::ScheduledSet.new
  return false if pending.find { |job| job.jid == jid }
  return false if waiting.find { |job| job.jid == jid }
  return false if working.find { |process_id, thread_id, work| work["payload"]["jid"] == jid }
  true
  end

end