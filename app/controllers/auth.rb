get '/' do
  if current_user
    @user = User.find(current_user.id)
    @content = params[:content]
    erb :welcome
  else
  	erb :welcome
  end
end

post '/post_tweet' do
  if current_user
    @user = User.find(current_user.id)
    data = {}
  	  unless (params[:content]).nil?
  	  	if request.xhr?
  	      if (params[:time]).to_i <= 60
	        jid = @user.tweet_later(params[:time],params[:content])
	        data[jid:] = jid
	        data 
            return {jid: jid}.to_json
	        redirect '/'
	      elsif (params[:time]).to_i == "now"
	        jid = @user.tweet_later(params[:time],params[:content])
            return {jid: jid}.to_json
	        redirect '/'
          else
            redirect '/'
          end
        end
     end
  end
end

# get '/timeline' do
#   @user = User.find(current_user.id)
#   if @user.tweets.size == 1
#   	@user.recent_tweets
#   	@short_timeline = @user.tweets
#   	erb :timeline, :layout => false
#   elsif @user.tweets_stale?
#     @user.tweets.each {|tweet| tweet.destroy}
#     @user.recent_tweets
#     @short_timeline = @user.tweets
#     erb :timeline, :layout => false
#   else
#     @short_timeline = @user.tweets
#     erb :timeline, :layout => false
#   end
# end


get '/recent_tweets/:twitter_handle' do
	@user = User.find_by(twitter_handle: params[:twitter_handle])
	if @user.tweets_stale?
	  @user.tweets.each {|tweet| tweet.destroy}
	  @recent_tweets = @user.recent_tweets
	  erb :user_tweets
    else
	  @recent_tweets = @user.tweets
	  erb :user_tweets
  end
end

get '/auth' do
  redirect "/auth/twitter"
end

get '/logout' do
  session.clear
  redirect '/'
end


get '/status/:job_id' do
@work_complete = TweetWorker.job_is_complete(params[:job_id])
  if @work_complete
  	return "true"
  else
  	return "false"
  end
end


get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  @user = User.find_or_create_by(name:env['omniauth.auth']['info']['name'],
  token:env['omniauth.auth']['credentials']['token'],
  token_secret:env['omniauth.auth']['credentials']['secret'],
  twitter_handle:env['omniauth.auth']['extra']['raw_info']['screen_name'])
  session[:user_id] = @user.id
  redirect '/'
end

get '/auth/failure' do
  params[:message]
end
