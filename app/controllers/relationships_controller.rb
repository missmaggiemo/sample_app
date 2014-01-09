class RelationshipsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    # for Ajax
    respond_to do |format|
      # depending on the request, this only executes one of the following two lines:
      format.html {redirect_to @user}
      # called w/ non-Ajax request
      format.js
      # called w/ Ajax request
    end
    # w/out Ajax
    # redirect_to @user
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end