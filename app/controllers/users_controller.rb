class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def index
    # @user = User.find(params[:id])
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create 
    @user = User.new(user_params)
    if @user.save
      # if the user has entered all the information
      sign_in @user
      # from sessions_helper.rb
      flash[:success] = "Welcome to the Sample App!"
      # the code to display the flash is in application.html.erb
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
  
  
  # signed_in_user and correct_user are before_actions
  
  def edit
    # @user = User.find(params[:id])
    # already in correct_user
  end
  
  def update
    # @user = User.find(params[:id])
    # already in correct_user
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      # sign_in @user
      # was having problem with specs-- you shouldn't be able to update user info w/out being signed in
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  
  # private methods
  
  private
  
  # users should not be able to access/edit all user account info-- for example, if there are admin users, there would be an admin parameter in the DB and if a user had access to that, he could make himself an admin
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  # before filters
  def signed_in_user
    # redirect_to signin_url, notice: "Please sign in." unless signed_in?
    unless signed_in?
      store_location
      # in sessions helper
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
end
