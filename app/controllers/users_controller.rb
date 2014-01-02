class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create 
    @user = User.new(user_params)
    if @user.save
      # if the user has entered all the information
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # send user to their user page
    else
      render 'new'
      # render new.html.erb with errors
    end
  end
  
  def signin
  end
  
  def show
    @user = User.find(params[:id])
    # for show.html.erb, render page based on user.id
  end
  
  # private methods
  
  private
  
  # users should not be able to access/edit all user account info-- for example, if there are admin users, there would be an admin parameter in the DB and if a user had access to that, he could make himself an admin
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
