include ApplicationHelper

RSpec::Matchers.define :have_h1 do |heading|
  match do |page|
    expect(page).to have_selector('h1', text: heading)
  end
end

RSpec::Matchers.define :have_full_title do |title|
  match do |page|
    expect(page).to have_title(full_title(title))
  end
end

RSpec::Matchers.define :add_blank_user do
  match do |page|
    expect {click_button "Create my account"}.to change(User, :count)
  end
end

RSpec::Matchers.define :show_error do
  match do |page|
    expect(page).to have_content('error')
  end
end

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

def create_tom_cat
  fill_in "Name", with: "Tom"
  fill_in "Email", with: "Tom@cat.com"
  fill_in "Password", with: "sammycat"
  fill_in "Confirmation", with: "sammycat"
  click_button "Create my account"
end

RSpec::Matchers.define :have_name_in_title do
  match do |page|
    expect(page).to have_title("Tom")
  end
end

RSpec::Matchers.define :have_signout_link do
  match do |page|
    expect(page).to have_link("Sign out", href: signout_path)
  end
end

RSpec::Matchers.define :have_signin_link do
  match do |page|
    expect(page).to have_link("Sign in", href: signin_path)
  end
end

RSpec::Matchers.define :welcome_user do
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: 'Welcome')
  end
end

RSpec::Matchers.define :have_change_gravatar_link do
  match do |page|
    expect(page).to have_link('change', href: 'http://gravatar.com/emails')
  end
end

RSpec::Matchers.define :show_updated do
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: 'updated')
  end
end

def follow_sign_out
  click_link "Sign out"
end