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
      @user = current_user
      @dogs = @user.dogs
      erb :'dogs/show_all'
    else
      redirect "/login?failed=yes"
    end
  end

  get '/dogs/new' do
    logged_in? ? (erb :'dogs/new') : (redirect "/login?failed=yes")
  end

  post '/dogs/new' do
    @user = current_user
    @dog = @user.dogs.build(name: params[:dog][:name], age:params[:dog][:age])
    @dog.breed = params[:dog][:breed].keys.first if !!params[:dog][:breed]
    @dog.breed = params[:new_breed] if !params[:new_breed].empty?
    @user.save
    @place = place(@user.dogs.size)
    redirect "/dogs/#{@dog.slug}?new=#{@place}"
  end

  get '/dogs/:slug' do
    if logged_in?
      @dog = Dog.find_by_slug(params[:slug])
      erb :'dogs/show_one'
    else
      redirect "/login?failed=yes"
    end
  end

  get '/dogs/:slug/edit' do
    if logged_in?
      @dog = Dog.find_by_slug(params[:slug])
      erb :'dogs/edit'
    else
      redirect "/login?failed=yes"
    end
  end

  post '/dogs/:slug/edit' do
    @dog = Dog.find_by_slug(params[:slug])
    @dog.name = params[:name] if !params[:name].empty?
    @dog.age = params[:age] if !params[:age].empty?
    @dog.breed = params[:breed].keys.first if !!params[:breed]
    @dog.breed = params[:new_breed] if !params[:new_breed].empty?
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
