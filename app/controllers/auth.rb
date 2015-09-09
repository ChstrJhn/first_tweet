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
  	@client = @user.twitter_client
	@client.update(params[:content])
	redirect '/'
  end
end

get '/timeline' do
  @user = User.find(current_user.id)
  @client = @user.twitter_client
  @twitter_user = @client.user_timeline
  @short_timeline = @twitter_user.take(10)
  erb :timeline, :layout => false 
end

get '/auth' do
  redirect "/auth/twitter"
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  @user = User.find_or_create_by(name:env['omniauth.auth']['info']['name'],
  token:env['omniauth.auth']['credentials']['token'],
  token_secret:env['omniauth.auth']['credentials']['secret'],
  twitter_handle:env['omniauth.auth']['uid'])
  @user.twitter_client
  session[:user_id] = @user.id
  redirect '/'
end

get '/auth/failure' do
  params[:message]
end
