class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user.send_activation_email
        flash[:notice] = "#{@user.send_activation_email}Please check your email to activate your account."
      else
        flash[:alert] = "Can not send email now"
      end
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Update user information successfully"
    else
      render :edit
    end
  end

  private
    def set_user
      @user = User.find_by(id: params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
end end
