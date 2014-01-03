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

RSpec::Matchers.define :have_the_right_links_in_layout do
  match do |page|
    click_link "About"
    expect(page).to have_title(full_title("About"))
    click_link "Help"
    expect(page).to have_title(full_title("Help"))
    click_link "Contact"
    expect(page).to have_title(full_title("Contact"))
    click_link "Sign in"
    expect(page).to have_title(full_title("Sign In"))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title("Sign Up"))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end