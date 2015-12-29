class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      @user.save
      flash[:notice] = "#{@user.send_reset_email} \n Email sent with password reset instructions"
      redirect_to root_path
    else
      flash.now[:alert] = "Email address is not found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "Can't be empty")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:notice] = "Password has been reset."
      redirect_to @user
    else
      render :edit
    end
  end

  def edit
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        flash[:alert] = "Invalid user from this link"
        redirect_to root_path
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:alert] = "Password reset has expired"
        redirect_to new_password_reset_path
      end
    end
end
