class SessionsController < ApplicationController

  #GET /login
  def new

  end
#POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # => User object or false
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # remember user #save to DB + cookies[:token] #SessionsHelper
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
