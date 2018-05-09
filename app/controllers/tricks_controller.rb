require './config/environment'

class TricksController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/tricks/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      @dog = Dog.find_by_slug(params[:slug])
      erb :'tricks/new'
    else
      redirect "/login?failed=yes"
    end
  end

  post '/tricks/new' do
    @user = User.find(session[:user_id])
    @dog = Dog.find_by(id: params[:dog_id])
    params[:tricks].keys.each do |trick_name|
      @dog.tricks << Trick.find_by(name: trick_name)
    end
    @dog.tricks.build(params[:new_trick])
    @dog.save
    redirect "/dogs/#{@dog.slug}"
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
