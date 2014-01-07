FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Person #{n}"}
    sequence(:email) {|n| "person_#{n}@example.com"}
    password "sample"
    password_confirmation "sample"
    
    factory :admin do
      admin true
    end
  end
  # factory for user
  
  factory :micropost do
    content "Spam spam spam spam"
    user
  end
  # factory for micropost
end




# FactoryGirl.define do
#   factory :user do
#     name "Tweety"
#     email "tweety@bird.com"
#     password "puddycat"
#     password_confirmation "puddycat"
#   end
# end
