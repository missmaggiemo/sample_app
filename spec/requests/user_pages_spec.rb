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
        it {should have_content('error')}
      end
    
      describe "with valid info" do
        # let(:user) {FactoryGirl.create(:user)}
        before {create_new_user}
                
        it {should have_signout_link}
        it {should have_name_in_title}
        it {should_not have_content('error')}
        it {should welcome_user}
      end
    end
  end
  
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    before {visit user_path(user)}
    
    it {should have_content(user.name)}
    it {should have_title(user.name)}
  end
  
end
