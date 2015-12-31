class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]

  def following
    @title = "Following"
    @user = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

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
    @entries = @user.feed.paginate(page: params[:page])
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
    end

    def correct_user
      set_user
      unless @user == current_user
        flash[:alert] = "You do not have right to access this."
        redirect_to root_path
      end
    end
end
