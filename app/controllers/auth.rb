get '/' do
  @content = params[:content]
  erb :welcome
end

post '/post_tweet' do
	@content = params[:content]
	$twitter.update(params[:content])
	redirect '/'
end

get '/timeline' do
  @twitter_user = $twitter.user_timeline
  @short_timeline = @twitter_user.take(10)
  erb :timeline, :layout => false 
end

# get '/updated_tweet' do
# 	erb :updated_tweet
# end


# get '/login' do
  
# end

# get '/signup' do
  
# end
