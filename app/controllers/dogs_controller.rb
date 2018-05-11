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
    @dog = @user.dogs.build(name: params[:dog][:name], age: params[:dog][:age], user_id: @user.id)
    @dog.breed = params[:dog][:breed].keys.first if !!params[:dog][:breed]
    @dog.breed = params[:new_breed] if !params[:new_breed].empty?
    @user.save
    @place = place(@user.dogs.size)
    redirect "/dogs/#{@dog.id}?new=#{@place}"
  end

  get '/dogs/:id' do
    if logged_in?
      @dog = Dog.find_by(id: params[:id])
      @user = current_user
      erb :'dogs/show_one'
    else
      redirect "/login?failed=yes"
    end
  end

  get '/dogs/:id/edit' do
    if logged_in?
      @dog = Dog.find_by(id: params[:id])
      @dog.user == current_user ? (erb :'dogs/edit') : (redirect "/home?auth=no")
    else
      redirect "/login?failed=yes"
    end
  end

  post '/dogs/:id/edit' do
    @user = current_user
    @dog = Dog.find_by(id: params[:id])
    @dog.name = params[:name] if !params[:name].empty?
    @dog.age = params[:age] if !params[:age].empty?
    @dog.breed = params[:breed].keys.first if !!params[:breed]
    @dog.breed = params[:new_breed] if !params[:new_breed].empty?
    @dog.save
    @user.save
    redirect "/dogs/#{@dog.id}"
  end

  get '/dogs/:id/tricks/edit' do
    if logged_in?
      @dog = Dog.find_by(id: params[:id])
      @dog.user == current_user ? (erb :'dogs/tricks_edit') : (redirect "/home?auth=no")
    else
      redirect "/login?failed=yes"
    end
  end

  post '/dogs/:id/tricks/edit' do
    @dog = Dog.find_by(id: params[:id])
    @tricks = @dog.tricks
    delete_array = []
    params[:trick].keys.each do |key|
      delete_array << Trick.find_by(id: key)
    end
    @dog.tricks = @tricks-delete_array
    @dog.save
    redirect "/dogs/#{@dog.id}"
  end

  get '/dogs/:id/delete' do
    if logged_in?
      @user = current_user
      @dog = Dog.find_by(id: params[:id])
      erb :'dogs/delete'
    else
      redirect "/login?failed=yes"
    end
  end

  post '/dogs/:id/delete' do
    @dog = Dog.find_by(id: params[:id])
    @user = current_user
    @dog.delete
    @user.save
    redirect '/dogs'
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
