require 'spec_helper'

describe "User pages" do
  subject {page}
  
  shared_examples_for "all pages" do
    it {should have_selector('h1', text: heading)}
    it {should have_title(full_title(page_title))}
  end
  
  describe "signup page" do
    before {visit signup_path}
    let(:heading) {'Sign Up'}
    let(:page_title) {'Sign Up'}
    
    describe "layout" do
      it_should_behave_like "all pages"
    end
    
    let(:submit) {"Create my account"}
    
    describe "signup button" do
      it "doesn't add blank user" do
        expect {click_button submit}.not_to change(User, :count)
      end
      
      describe "displays errors" do
        before {click_button submit}
        
        it {should have_title('Sign Up')}
        it {should have_content('error')}
      end
    
      describe "with valid info" do
        before do
          fill_in "Name", with: "Freddy"
          fill_in "Email", with: "Freddy@mercury.com"
          fill_in "Password", with: "bohemian"
          fill_in "Confirmation", with: "bohemian"
        end
      
        it "should add user" do
          expect {click_button submit}.to change(User, :count).by(1)
        end
        
        describe "after saving the user" do
          before {click_button submit}
          let(:user) {User.find_by(email: "freddy@mercury.com")}
          
          it {should have_link('Sign out')}
          it {should have_title(user.name)}
          it {should have_selector('div.alert.alert-success', text: 'Welcome')}
        end
      end
    end
  end
  
  # describe "signin page" do
#     before {visit signin_path}
#     let(:heading) {'Sign In'}
#     let(:page_title) {'Sign In'}
#     
#     it_should_behave_like "all pages"
#   end

# test for this in authentication pages
  
  describe "profile page" do
    before {visit user_path(user)}
    let(:user) {FactoryGirl.create(:user)}
    # as opposed to User.create(name: 'Barney', email: 'Barney@rubble.com', password: 'yabbadabba', password_confirmation: 'yabbadabba')
    
    it {should have_content(user.name)}
    it {should have_title(user.name)}
  end
  
end
