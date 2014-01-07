require 'spec_helper'
# all support pages are added by spec_helper

describe "Static pages" do
  
  subject {page}
  
  shared_examples_for "all static pages" do
    it {should have_h1(heading)}
    it {should have_full_title(page_title)}
  end
  
  describe "Home page" do
    before {visit root_path}
    let(:heading) {'Sample App'}
    let(:page_title) {''}
    
    it_should_behave_like "all static pages"
    it {should_not have_full_title('Home')}
    
    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Beware the Jabberwocky!")
        FactoryGirl.create(:micropost, user: user, content: "We're all mad here.")
        sign_in user
        visit root_path
      end
      
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      
      it {should have_link("delete")}
    end
  end
  
  describe "Help page" do
    before {visit help_path}
    let(:heading) {'Help'}
    let(:page_title) {'Help'}
    
    it_should_behave_like "all static pages"
  end
  
  describe "About page" do
    before {visit about_path}
    let(:heading) {'About'}
    let(:page_title) {'About'}
    
    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before {visit contact_path}
    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}
    
    it_should_behave_like "all static pages"
  end
  
  describe "check layout links" do
    before {visit root_path}
    it {should have_the_right_links_in_layout}
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
