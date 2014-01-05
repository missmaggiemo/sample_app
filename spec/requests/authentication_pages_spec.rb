require 'spec_helper'
# all support pages are added by spec_helper

describe "Authentication" do
  
  subject {page}
  
  describe "signin" do
    before {visit signin_path}
    
    it {should have_content ("Sign In")}
    it {should have_title("Sign In")}
    
    describe "with invalid info" do
      before {click_button "Sign in"}
      
      it {should have_title("Sign In")}
      it {should have_error_message("Invalid")}
      
      describe "after visiting another page" do
        before {click_link "Home"}
        it {should_not have_error_message("Invalid")}
      end
    end
    
    describe "with valid info" do
      let(:user) {FactoryGirl.create(:user)}
      before {sign_in user}
            
      it {should have_title(user.name)}
      it {should have_link('Users', href: users_path)}
      it {should have_profile_link}
      it {should have_link('Settings', href: edit_user_path(user))}
      it {should have_signout_link}
      it {should_not have_signin_link}
      
      describe "index works" do
        before {click_link "Users"}
        it {should have_title("All Users")}
      end
      
      describe "followed by signout" do
        before {click_link "Sign out"}
        it {should have_signin_link}
      end
      
    end
  end
  
  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      
      describe "when trying to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        
        describe "after signing in" do 
          it {should render_edit_page}
        end
      end
      
      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before {visit edit_user_path(user)}
          it {should have_title("Sign In")}
        end
        
        describe "submitting to the update action" do
          before {patch user_path(user)}
          specify {expect(response).to redirect_to(signin_path)}
        end
        
        describe "visiting the user index" do
          before {visit users_path}
          it {should have_title("Sign In")}
        end
        
      end
    end
    
    describe "for wrong user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@bird.com")}
      before {sign_in user, no_capybara: true}
      
      describe "submitting a GET request to the User#edit action" do
        before {get edit_user_path(wrong_user)}
        specify {expect(response.body).not_to match(full_title('Edit user'))}
        # full_title in application_helper
        specify {expect(response).to redirect_to(root_url)}
      end
      
      describe "submitting a PATCH request to the Users#update action" do
        before {patch user_path(wrong_user)}
        specify {expect(response).to redirect_to(root_url)}
      end
      
    end
    
    describe "non-admin user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:non_admin) {FactoryGirl.create(:user)}
      
      before {sign_in non_admin, no_capybara: true}
      
      describe "submitting a DELETE request to the User#destroy action" do
        before {delete user_path(user)}
        specify {expect(response).to redirect_to(root_url)}
      end
      
    end
    
    describe "admin user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:admin_role) {FactoryGirl.create(:admin)}
      
      before {sign_in admin_role, no_capybara: true}
          
      describe "submitting a DELETE request to the User#destroy action" do
        before {delete user_path(user)}
        specify {expect(response).not_to redirect_to(root_url)}
      end
      
      describe "submitting a DELETE request on self" do
        before {delete user_path(admin_role)}
        describe "redirects to profile" do
          specify {expect(response).to redirect_to(user_path(admin_role))}
        end
      end
      
    end
    
  end
  
end


