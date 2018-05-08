require './config/environment'

class DogsController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/dogs' do
    if logged_in?
      @user = User.find(session[:user_id])
      @dogs = @user.dogs
      erb :'dogs/show_all'
    else
      redirect "/login?failed=yes"
    end
  end

  get '/dogs/new' do
    logged_in? ? (erb :'dogs/new') : (redirect "/login?failed=yes")
  end

  post '/dogs' do
    binding.pry
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
