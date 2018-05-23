require './config/environment'
require_relative "concerns/helpers.rb"

class TricksController < Sinatra::Base

  helpers ApplicationHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/tricks' do
    redirect "/login?failed=yes" if !logged_in?
    @tricks = current_user.tricks.uniq
    erb :'tricks/breakdown'
  end

  get '/tricks/new' do
    redirect "/login?failed=yes" if !logged_in?
    @dog = Dog.find_by(id: params[:id])
    erb :'tricks/new'
  end

  post '/tricks/new' do
    @dog = Dog.find_by(id: params[:dog_id])

    @dog.tricks += params[:tricks].keys.collect{|trick_name| Trick.find_by(name: trick_name)} if !!params[:tricks]

    if !params[:new_trick][:name].empty?
      if !!Trick.find_by(name: params[:new_trick][:name])
        shorten = Trick.find_by(name: params[:new_trick][:name])
        @dog.tricks << shorten if !@dog.tricks.include?(shorten)
      else
        @dog.tricks.build(params[:new_trick])
      end
    end

    @dog.save
    redirect "/dogs/#{@dog.id}?trick=#{place(@dog.tricks.size)}"
  end

  get '/tricks/:id' do
    redirect "/login?failed=yes" if !logged_in?
    @trick = Trick.find_by(id: params[:id])
    erb :'tricks/show_one'
  end
end
