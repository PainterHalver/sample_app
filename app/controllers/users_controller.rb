class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "signup.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  private
  def user_params
    # Strong Parameters
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end
end
