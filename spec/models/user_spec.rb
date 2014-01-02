# ALWAYS WRITE TESTS FIRST

require 'spec_helper'

# describe User do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

describe User do
  
  before {@user = User.new(name: "Douglas", email: "Douglas@adams.com", password: "dontpanic", password_confirmation: "dontpanic")}
  
  subject {@user}
  
  # this is how you test to make sure you have the rigt columns in your DB 
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)}
  
  it {should be_valid}
  
  
  # test for presence confirmartion
  
  describe "when name not present" do
    before { @user.name = "" }
    it {should_not be_valid}
  end
  
  describe "when email not present" do
    before { @user.email = "" }
    it {should_not be_valid}
  end
  
  # test for valid email checks
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w{user@foo,com user_at_foo.com example.user@foo. foo@bar_baz.com foo@bar+baz.com foo@bar..com}
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
  
  # test for email saved as lowercase
  
  describe "mixed-case email" do
    let(:mixed_case) {"FRED@FlintStone.com"}
    
    it "should be saved as all lowercase" do
      @user.email = mixed_case
      @user.save
      expect(@user.reload.email).to eq mixed_case.downcase
    end
  end
  
  # test for uniqueness checks
  
  describe "when email address is already taken" do
    before  do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it {should_not be_valid}
  end
  
  # test for password stuff-- presence
  
  describe "when password is not present" do
    before do
      @user = User.new(name: "Tom", email: "Tom@Jerry.com", password: "", password_confirmation: "")
    end
    it {should_not be_valid}
  end
  
  # test for password stuff-- confirmation
  
  describe "when password doesn't match confirmation" do
    before {@user.password_confirmation = "mismatch"}
    it {should_not be_valid}
  end
  
  # test for password stuff-- min length
  
  describe "with a password that's too short" do
    before {@user.password = @user.password_confirmation = "a"*5}
    it {should be_invalid}
  end
  
  # test for password stuff-- authenticate
  
  describe "return value of authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by(email: @user.email)}
    
    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) {found_user.authenticate("invalid")}
      
      it {should_not eq user_for_invalid_password}
      specify {expect(user_for_invalid_password).to be_false}
      # 'specify' is a synonym for 'it', used for readability
    end
  end
  
  describe "remembers token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
    # same as it {expect(@user.remember_token).to_not be_blank}
  end
  
end