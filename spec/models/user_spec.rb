require 'spec_helper'

# describe User do
#   pending "add some examples to (or delete) #{__FILE__}"
# end


describe User do
  
  before {@user = User.new(name: "Example", email: "Example@sample.com")}
  
  subject {@user}
  
  it {should be_valid}
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  
  describe "when name not present" do
    before { @user.name = "" }
    it {should_not be_valid}
  end
  
  describe "when email not present" do
    before { @user.email = "" }
    it {should_not be_valid}
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w{user@foo,com user_at_foo.com example.user@foo. foo@bar_baz.com foo@bar+baz.com}
      addresses.each do |invalid|
        @user.email = invalid
        expect(@user).not_to be_valid
      end
    end
    
    it "should be valid" do
      addresses = %w{user@foo.com user@foo.COM example.user@foo.com foo@bar.baz.com foo_-+.bar@baz.com}
      addresses.each do |valid|
        @user.email = valid
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    before  do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it {should_not be_valid}
  end
  
end