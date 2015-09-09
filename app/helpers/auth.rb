def current_user
@all_users = User.all
  if session[:user_id] && @all_users.empty? == false
    return User.find(session[:user_id])
  else
    return nil
  end
end
