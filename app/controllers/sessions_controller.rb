class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_login user
    else
      flash[:danger] = t "login_invalid_msg"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def remember_user user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def check_login user
    if user.activated?
      log_in user
      remember_user user
      redirect_back_or user
    else
      message = t ".msg_not_active"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
