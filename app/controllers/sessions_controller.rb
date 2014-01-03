class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_to user, :notice => "Signed in!"
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
