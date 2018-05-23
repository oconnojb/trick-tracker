require './config/environment'
require_relative "concerns/helpers.rb"

class ApplicationController < Sinatra::Base

  helpers ApplicationHelper

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
    erb :'users/home'
  end

  get '/login' do
    logged_in? ? (redirect '/home') : (erb :'users/login')
  end

  post '/login' do
    none_empty = !params[:user][:email].empty? && !params[:user][:password].empty?
    @user = User.find_by(email: params[:user][:email]) if !!none_empty
    user_password_match = (@user!=nil) && (!!@user.authenticate(params[:user][:password]))
    redirect "/login?failed=yes" if !user_password_match
    session[:user_id] = @user.id
    redirect '/home'
  end

  get '/edit' do
    redirect "/login?failed=yes" if !logged_in?
    erb :'users/edit'
  end

  post '/edit' do
    if !params[:password].empty? && !!current_user.authenticate(params[:password])
      current_user.name = params[:name] if !params[:name].empty?
      current_user.email = params[:email] if !params[:email].empty?
      current_user.password = params[:new_password] if !params[:new_password].empty?
      current_user.save
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
    erb :'users/delete'
  end

  post '/delete' do
    if !params[:password].empty? && !!current_user.authenticate(params[:password])
      current_user.dogs.each do |dog|
        DogTrick.all.each do |row|
          row.delete if row.dog_id == dog.id
        end
        dog.delete
      end
      current_user.delete
      session.clear
      redirect '/'
    else
      redirect "/delete?failed=yes"
    end
  end
end
