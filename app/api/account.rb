post '/account/signup' do
  user = User.create!(
    username: params[:username],
    email: params[:email],
    password: params[:password]
  )
  json(user)
end
