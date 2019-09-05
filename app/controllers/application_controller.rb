require './config/environment'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base


  configure do
    register Sinatra::Flash
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"

  end

  get "/" do
    erb :welcome
  end

  get '/signup' do
    erb :"/users/signup"
  end

  post '/signup' do
    if log_in?
      redirect to "/users/#{session[:user_id]}"
    else
      @user=User.create(params[:user])
      if @user.valid?
        session[:user_id]=@user.id
        redirect to "/users/#{@user.id}"
      else
        flash[:error]="Did you submit a blank username, email or password? Or did you give me a registered email? That's not acceptable, try again please! "
        redirect to "/signup"
      end
    end
  end

  get '/login' do
    if session[:user_id]
      redirect to "/users/#{session[:user_id]}"
    else
      erb :"/users/login"
    end
  end

  post '/login' do
    @user=User.find_by :email=>params[:email]
    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.id
      redirect to "/users/#{@user.id}"
    else
      flash[:error]="That combination doesn't exist!"
      redirect to "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  helpers do


      def current_user
        User.find_by :id=>session[:user_id]
      end

      def log_in?
        !!session[:user_id]
      end




  end

end
