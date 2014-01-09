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
      let(:user2) {FactoryGirl.create(:user)}
      let(:user3) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Beware the Jabberwocky!")
        FactoryGirl.create(:micropost, user: user, content: "We're all mad here.")
        FactoryGirl.create(:micropost, user: user2, content: "Why, sometimes I've believed as many as six impossible things before breakfast.")
      end
      
      describe "for user with multiple posts" do
        before do
          sign_in user
          visit root_path
        end
        after {follow_sign_out}
        
        describe "user's feed" do
          it "should be rendered" do
            user.feed.each do |item|
              expect(page).to have_selector("li##{item.id}", text: item.content)
            end
          end
        
          it {should have_link("delete")}
          
          it "should have correct post pluralization" do
            expect(page).to have_selector('span', text: "#{user.feed.count} posts")
          end
        end
        
        describe "pagination" do
          before do
            40.times do
              FactoryGirl.create(:micropost, user: user)
            end
            visit root_path
          end
          
          it {should have_selector('div.pagination')}
        end
        
        describe "follower/following counts" do
          before do
            user2.follow!(user)
            user.follow!(user2)
            user.follow!(user3)
            visit root_path
          end
          it {should have_link("2 following", href: following_user_path(user))}
          it {should have_link("1 followers", href: followers_user_path(user))}
        end
        
      end
        
      describe "for user with one post" do
        before do
          sign_in user2
          visit root_path
        end
        after {follow_sign_out}
        
        # it {should_not have_link("0 followers")}
        # for some reason, user2 and user3 don't keep user as a follower after user signs out-- why?
        
        describe "feed" do
          it "should have correct post count & pluralization" do
            expect(page).to have_selector('span', text: '1 post')
          end
          
          it {should_not have_selector('div.pagination')}
        end
      end  
        
      describe "for user with no posts" do
        before do
          sign_in user3
          visit root_path
        end
        after {follow_sign_out}
      
        describe "feed" do
          it "should have correct post coutnt & pluralization" do
            expect(page).to have_selector('span', text: '0 posts')
          end
        end
        
        describe "another user's feed" do
          before do
            click_link 'Users'
            click_link user.name
          end
          
          it {should_not have_link 'delete'}
        end
      end
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

