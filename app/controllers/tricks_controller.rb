require './config/environment'

class TricksController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/tricks' do
    redirect "/login?failed=yes" if !logged_in?
    @user = current_user
    @tricks = @user.tricks.uniq
    erb :'tricks/breakdown'
  end

  get '/tricks/new' do
    redirect "/login?failed=yes" if !logged_in?
    @user = current_user
    @dog = Dog.find_by(id: params[:id])
    erb :'tricks/new'
  end

  post '/tricks/new' do

    @user = current_user
    @dog = Dog.find_by(id: params[:dog_id])

    if !!params[:tricks]
      params[:tricks].keys.each do |trick_name|
        @dog.tricks << Trick.find_by(name: trick_name)
      end
    end

    if !!Trick.find_by(name: params[:new_trick][:name])
      shorten = Trick.find_by(name: params[:new_trick][:name])
      @dog.tricks << shorten if !@dog.tricks.include?(shorten)
    else
      @dog.tricks.build(params[:new_trick])
    end
    @dog.save
    @user.save
    redirect "/dogs/#{@dog.id}"
  end

  get '/tricks/:id' do
    redirect "/login?failed=yes" if !logged_in?
    @user = current_user
    @trick = Trick.find_by(id: params[:id])
    erb :'tricks/show_one'
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
