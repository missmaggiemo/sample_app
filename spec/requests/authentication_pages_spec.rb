require 'spec_helper'
require 'support/auth_pages_utl'

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
      before {valid_signin(user)}
      
      it {should have_title(user.name)}
      it {should have_profile_link}
      it {should have_signout_link}
      it {should_not have_signin_link}
      
      describe "followed by signout" do
        before {click_link "Sign out"}
        it {should have_signin_link}
      end
      
    end
  end
  
end



# describe "AuthenticationPages" do
#   describe "GET /authentication_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get authentication_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end
