require './config/environment'
require_relative "concerns/helpers.rb"

class DogsController < Sinatra::Base

  helpers ApplicationHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/dogs' do
    redirect "/login?failed=yes" if !logged_in?
    @dogs = current_user.dogs
    erb :'dogs/show_all'
  end

  get '/dogs/new' do
    logged_in? ? (erb :'dogs/new') : (redirect "/login?failed=yes")
  end

  post '/dogs/new' do
    @dog = current_user.dogs.build(name: params[:dog][:name], age: params[:dog][:age], user_id: current_user.id)
    @dog.breed = params[:dog][:breed].keys.first if !!params[:dog][:breed]
    @dog.breed = params[:new_breed] if !params[:new_breed].empty?
    current_user.save
    redirect "/dogs/#{@dog.id}?new=#{place(current_user.dogs.size)}"
  end

  get '/dogs/:id' do
    redirect "/login?failed=yes" if !logged_in?
    @dog = Dog.find_by(id: params[:id])
    erb :'dogs/show_one'
  end

  get '/dogs/:id/edit' do
    redirect "/login?failed=yes" if !logged_in?
    @dog = Dog.find_by(id: params[:id])
    @dog.user == current_user ? (erb :'dogs/edit') : (redirect "/home?auth=no")
  end

  post '/dogs/:id/edit' do
    @dog = Dog.find_by(id: params[:id])
    @dog.name = params[:name] if !params[:name].empty?
    @dog.age = params[:age] if !params[:age].empty?
    @dog.breed = params[:breed].keys.first if !!params[:breed]
    @dog.breed = params[:new_breed] if !params[:new_breed].empty?
    @dog.save
    redirect "/dogs/#{@dog.id}"
  end

  get '/dogs/:id/tricks/edit' do
    redirect "/login?failed=yes" if !logged_in?
    @dog = Dog.find_by(id: params[:id])
    @dog.user == current_user ? (erb :'dogs/tricks_edit') : (redirect "/home?auth=no")
  end

  post '/dogs/:id/tricks/edit' do
    @dog = Dog.find_by(id: params[:id])
    @tricks = @dog.tricks
    delete_array = params[:trick].keys.collect{|key| Trick.find_by(id: key)}
    @dog.tricks = @tricks - delete_array
    @dog.save
    redirect "/dogs/#{@dog.id}"
  end

  get '/dogs/:id/delete' do
    redirect "/login?failed=yes" if !logged_in?
    @user = current_user
    @dog = Dog.find_by(id: params[:id])
    @dog.user == @user ? (erb :'dogs/delete') : (redirect "/home?auth=no")
  end

  post '/dogs/:id/delete' do
    @dog = Dog.find_by(id: params[:id])
    DogTrick.all.each do |row|
      row.delete if row.dog_id == @dog.id
    end
    @dog.delete
    current_user.save
    redirect '/dogs'
  end
end
