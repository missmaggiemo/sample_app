require 'spec_helper'

describe Micropost do
  
  let(:user) {FactoryGirl.create(:user)}
  # let(:micropost) {FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)} # creates micropost
  # in ActiveRecord created_at and updated_at are "magic" columns with automatically set values-- not editable in DB, but we can set them w/ FactoryGirl
  
  before {@micropost = user.microposts.build(content: "Loren ipsum")}
  # 'build' instead of 'new'-- OOB (out of box), this fails
  
  # before do
#     # this code is not "the rails way", but the test passes
#     @micropost = Micropost.new(content: "Loren ipsum", user_id: user.id)
#   end
  
  subject {@micropost}
  
  it {should respond_to(:content)}
  it {should respond_to(:user_id)}
  # these two tests, respond_to(:content) and respond_to(:user_id) pass w/out doing anything to microposts.rb
  it {should respond_to(:user)}
  its(:user) {should eq user}
  
  describe "when user_id isn't preset" do
    before {@micropost.user_id = nil}
    it {should_not be_valid}
  end
  
  describe "w/ blank content" do
    before {@micropost.content = ''}
    it {should_not be_valid}
  end
  
  describe "with content that is too long" do
    before {@micropost.content = 'a' * 141}
    it {should_not be_valid}
  end
  
end
