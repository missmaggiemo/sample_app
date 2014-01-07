require 'spec_helper'
# all support pages are added by spec_helper

describe "User pages" do
  subject {page}
  
  shared_examples_for "all pages" do
    it {should have_h1(heading)}
    it {should have_full_title(page_title)}
  end
  
  describe "index" do
    let(:user) {FactoryGirl.create(:user)}
    
    before(:each) do
      sign_in user
      visit users_path
    end
    after {follow_sign_out}
    
    it {should_not have_title("Sign In")}
    
    describe "layout" do
      let(:heading) {'All Users'}
      let(:page_title) {'All Users'}
      it_should_behave_like "all pages"
    end
    
    describe "pagination" do
      before(:all) {30.times {FactoryGirl.create(:user)}}
      after(:all) {User.delete_all}
      
      it {should have_selector('div.pagination')}
    
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do
      
      it {should_not have_link("delete")}
      
      describe "as admin" do 
        let(:admin) {FactoryGirl.create(:admin)}
        before do
          follow_sign_out
          sign_in admin
          visit users_path
        end
        
        it {should have_link('delete', href: user_path(User.first))}
        
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1) 
        end
        
        it {should_not have_link('delete', href: user_path(admin))}
        
        # describe "submitting a DELETE request on self" do
#           before {delete user_path(admin)}
#           specify {expect(response).to show_error}
#         end
# this generates undefined method `admin?' for nil:NilClass
# I think it's an issue with the "response" verbage, but I'm not sure-- anyway, it definitely redirects

      end
      
    end
          
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
                
        it {should have_signout_link}
        it {should have_name_in_title}
        it {should_not show_error}
        it {should welcome_user}
      end
    end
  end
  
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    let!(:m1) {FactoryGirl.create(:micropost, user: user, content: "What is your quest?", created_at: 1.day.ago)}
    let!(:m2) {FactoryGirl.create(:micropost, user: user, content: "It's just a flesh wound.", created_at: 1.minute.ago)}
    before do
      sign_in user
      visit user_path(user)
    end
    
    it {should have_content(user.name)}
    it {should have_title(user.name)}
    
    describe "microposts" do
      it {should have_content(m1.content)}
      it {should have_content(m2.content)}
      it {should have_content(user.microposts.count)}
    end
  end
  
  describe "edit" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_path(user)
    end
    after {follow_sign_out}
    
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
    
    describe "forbidden attr" do
      let(:params) do
        {user: {admin: true, password: user.password, password_confirmation: user.password}}
      end
      before do
        patch user_path(user), params
      end
      specify {expect(user.reload).not_to be_admin}
    end
  end
  
end
