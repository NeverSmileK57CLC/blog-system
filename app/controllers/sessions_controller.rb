class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user, notice: "Log in successfully"
      else
        message = "Account is not activated. Check your email for the activation link."
        flash[:alert] = message
        redirect_to root_path
      end
    else
      flash.now[:alert] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    if logged_in?
      log_out
      flash.notice = "Log out successfully"
    end
    redirect_to login_path
  end
end
