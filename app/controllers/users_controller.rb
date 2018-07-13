class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_by, only: [:show, :edit, :update, :correct_user, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.paginate page: params[:page], per_page: 10
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "success"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    return if @user
    redirect_to home_path
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_ok"
      redirect_to users_url
    else
      flash[:warning] = t ".delete_error"
      redirect_to root_path
    end
  end


  private
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".danger_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_by
    @user = User.find_by id: params[:id]
  end
end
