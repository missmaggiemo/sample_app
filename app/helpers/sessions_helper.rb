module SessionsHelper
  
  def sign_in(user)
    # all of these methods can be found in the model user.rb
    remember_token = User.new_remember_token
    cookies[:remember_token] = { value: remember_token, expires: 7.days.from_now.utc } # 7.days.from_now.utc is a Rails time helper
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
    # defined below
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def signed_in_user
    # redirect_to signin_url, notice: "Please sign in." unless signed_in?
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  def current_user=(user)
    # current_user= means that the method will be used specifically to assign a value, like current_user = user
    @current_user = user
  end
  
  # if this were just a regular ruby class, we could define a method current_user to return the value of current_user, but that would be bad because the user's signin status would be forgotten when he went to another page
  
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token) 
    # ||= means "or equals", so if @current_user is undefined, it'll be assigned the value of user.find_by(remember_token: remember_token)
    # the first time .current_user is called, the ethod will call find_by
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def sign_out
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
    # session is like a cookie that disappears when the browser is closed-- but w/in rails
  end
  
  def store_location
    session[:return_to] = request.url if request.get?
    # request-- rails method-- gets URL of requested page
    # request.get? ensures that the request.url only runs if the request is a 'get'
  end
  
end
