include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # sign in when not using capybara
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

def follow_sign_out
  click_link "Sign out"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_profile_link do
  match do |page|
    expect(page).to have_link('Profile', href: user_path(user))
  end
end

RSpec::Matchers.define :have_signin_link do
  match do |page|
    expect(page).to have_link("Sign in", href: signin_path)
  end
end

RSpec::Matchers.define :have_signout_link do
  match do |page|
    expect(page).to have_link("Sign out", href: signout_path)
  end
end

