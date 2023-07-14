class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all
  end

  def show
    @pagy_microposts, @microposts = pagy @user.microposts.newest
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "signup.mail_check"
      redirect_to root_path
    else
      flash[:danger] = t "signup.signup_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "edit_user.user_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.user_deleted"
    else
      flash[:danger] = t "users.user_delete_failed"
    end
    redirect_to users_path
  end

  private
  def user_params
    # Strong Parameters
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "not_correct_user"
    redirect_to root_path
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "action_not_allowed"
    redirect_to root_path
  end
end
