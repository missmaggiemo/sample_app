include ApplicationHelper

def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
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

