require 'spec_helper'

describe "Static pages" do
  
  let(:base_title) {"Ruby on Rails Tutorial Sample App"}
  
  subject {page}
  
  describe "Home page" do
    before {visit root_path}
    
    it {should have_title(base_title)}
    it {should_not have_title(full_title('Home'))}
    it {should have_content('Sample App')}
  end
  
  describe "Help page" do
    before {visit help_path}
    
    it {should have_title(full_title('Help'))}
    it {should have_content('Help')}
  end
  
  describe "About page" do
    before {visit about_path}
    
    it {should have_title(full_title('About'))}
    it {should have_content('About')}
  end
  
  describe "Contact page" do
    before {visit contact_path}
    
    it {should have_title(full_title('Contact'))}
    it {should have_content('Contact')}
  end 
  
end



# require 'spec_helper'
# 
# describe "StaticPages" do
#   describe "GET /static_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get static_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end
