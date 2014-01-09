class SessionsController < ApplicationController
  
  def new
    redirect_to root_path if signed_in?
  end
  
  def create
    redirect_to root_path if signed_in?
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or root_path
      # redirect_back_or in session_helper
    else 
      flash.now[:error] = 'Invalid email/password combination' # flash.now will only show the flash on the immediate first page
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
end
