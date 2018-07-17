class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user,
    :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".check_mail_pls"
      redirect_to root_url
    else
      flash.now[:danger] = t ".mail_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].present?
      if @user.update_attributes user_params
        log_in @user
        @user.update_attribute :reset_digest, nil
        flash[:success] = t ".pass_reseted"
        redirect_to @user
      else
        render :edit
      end
    else
      @user.errors.add :password, :blank
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user.present?
    flash[:danger] = t ".mail_not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user&.activated? &&
              @user.authenticated?(:reset, params[:id])
    flash[:danger] = t ".error"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".reset_danger"
    redirect_to new_password_reset_url
  end
end
