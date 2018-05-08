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
    if logged_in?
      @user = User.find_by(id: session[:user_id])
      erb :'users/home'
    else
      redirect "/login?failed=yes"
    end
  end

  get '/login' do
    logged_in? ? (redirect '/home') : (erb :'users/login')
  end

  post '/login' do
    if !params[:user][:email].empty? && !params[:user][:password].empty?
      @user = User.find_by(email: params[:user][:email])
      if !!@user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        redirect '/home'
      else
        redirect "/login?failed=yes"
      end
    else
      redirect "/login?failed=yes"
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
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
      if integer > 0 && integer <= 10
        return placement_array[integer]
      else
        return integer
      end
    end
	end

end
