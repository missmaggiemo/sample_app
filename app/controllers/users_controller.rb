class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :followers, :following]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
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
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
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
      redirect_to root_path
    else
      render 'edit'
    end
  end
  
  def destroy
    other_user = User.find(params[:id])
    if current_user?(other_user)
      redirect_to user_path(current_user), notice: "Don't be stupid."
      # I'm not sure whether or not the notice really shows up, but the action definitely redirects to the user page.
    else
      other_user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end
  
  
  # private methods
  
  private
  
  # users should not be able to access/edit all user account info-- for example, if there are admin users, there would be an admin parameter in the DB and if a user had access to that, he could make himself an admin
  def user_params
    # strong params
    params.require(:user).permit(:name, :email, :username, :password, :password_confirmation)
  end
  
  # before filters
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
end
