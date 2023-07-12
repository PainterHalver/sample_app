class PasswordResetsController < ApplicationController
  before_action ->{load_user_by_email params.dig(:password_reset, :email)},
                only: :create
  before_action ->{load_user_by_email params[:email]}, only: %i(edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)
  def new; end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "forgot_password.email_sent"
      redirect_to root_path
    else
      flash.now[:danger] = t "forgot_password.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("errors.cant_be_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "forgot_password.success"
      redirect_to @user
    else
      flash[:danger] = t "forgot_password.fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user_by_email email
    @user = User.find_by email: email&.downcase
    return if @user

    flash[:danger] = t "forgot_password.email_not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "forgot_password.invalid_user"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "forgot_password.expired"
    redirect_to new_password_reset_path
  end
end
