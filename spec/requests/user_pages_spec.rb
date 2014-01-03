require 'spec_helper'
require 'support/user_pages_utl'

describe "User pages" do
  subject {page}
  
  shared_examples_for "all pages" do
    it {should have_h1(heading)}
    it {should have_full_title(page_title)}
  end
  
  describe "signup page" do
    before {visit signup_path}
    let(:heading) {'Sign Up'}
    let(:page_title) {'Sign Up'}
    
    describe "layout" do
      it_should_behave_like "all pages"
    end
        
    describe "signup button" do
      it {should_not add_blank_user}
      
      describe "displays errors" do
        before {click_button "Create my account"}
        
        it {should have_title('Sign Up')}
        it {should show_error}
      end
    
      describe "with brand-new valid info" do
        before {create_tom_cat}
        after {follow_sign_out}
                
        it {should have_signout_link}
        it {should have_name_in_title}
        it {should_not show_error}
        it {should welcome_user}
      end
    end
  end
  
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit user_path(user)
    end
    
    it {should have_content(user.name)}
    it {should have_title(user.name)}
  end
  
  describe "edit" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it {should have_content("Update Your Profile")}
      it {should have_title("Edit User")}
      it {should have_change_gravatar_link}
    end
    
    describe "with invalid info" do
      before {click_button "Save changes"}
      it {should show_error}
    end
    
    describe "with valid info" do
      let(:new_name) {"Silvester"}
      let(:new_email) {"silvester@cat.com"}
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end
      
      it {should have_title(new_name)}
      it {should show_updated}
      it {should have_signout_link}
      it {should_not have_signin_link}
      specify {expect(user.reload.name).to eq new_name}
      specify {expect(user.reload.email).to eq new_email}
    end
  end
  
end
