require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :'index'
  end

  get '/signup' do
    erb :'users/signup'
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
    "Home Page!"
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
