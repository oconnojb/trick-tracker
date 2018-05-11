require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    logged_in? ? (redirect '/home') : (erb :'index')
  end

  get '/signup' do
    logged_in? ? (redirect '/home') : (erb :'users/signup')
  end

  post '/signup' do
    if !params[:user][:name].empty? && !params[:user][:email].empty? && !params[:user][:password].empty?
      @user = User.create(params[:user])
      session[:user_id] = @user.id
      redirect '/home'
    else
      redirect "/signup?failed=yes"
    end
  end

  get '/home' do
    redirect "/login?failed=yes" if !logged_in?
    @user = User.find_by(id: session[:user_id])
    erb :'users/home'
  end

  get '/login' do
    logged_in? ? (redirect '/home') : (erb :'users/login')
  end

  post '/login' do
    truthiness = !params[:user][:email].empty? && !params[:user][:password].empty?
    @user = User.find_by(email: params[:user][:email]) if !!truthiness
    if (@user!=nil) && (!!@user.authenticate(params[:user][:password]))
      session[:user_id] = @user.id
      redirect '/home'
    else
      redirect "/login?failed=yes"
    end
  end

  get '/edit' do
    redirect "/login?failed=yes" if !logged_in?
    @user = current_user
    erb :'users/edit'
  end

  post '/edit' do
    @user = current_user
    if !params[:password].empty? || !!@user.authenticate(params[:password])
      @user.name = params[:name] if !params[:name].empty?
      @user.email = params[:email] if !params[:email].empty?
      @user.password = params[:new_password] if !params[:new_password].empty?
      @user.save
      redirect '/home'
    else
      redirect "/edit?failed=yes"
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/delete' do
    redirect "/login?failed=yes" if !logged_in?
    @user = current_user
    erb :'users/delete'
  end

  post '/delete' do
    @user = current_user
    if !params[:password].empty? || !!@user.authenticate(params[:password])
      @user.dogs.each do |dog|
        dog.delete
      end
      @user.delete
      session.clear
      redirect '/'
    else
      redirect "/delete?failed=yes"
    end
  end

  helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end

    def place(integer)
      placement_array = ['zeroth', 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth']
      if integer.between?(1, 10)
        return placement_array[integer]
      else
        return integer.to_s
      end
    end
	end

end
