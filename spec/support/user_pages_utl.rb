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

def create_new_user
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

RSpec::Matchers.define :welcome_user do
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: 'Welcome')
  end
end