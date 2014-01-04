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
end


# FactoryGirl.define do
#   factory :user do
#     name "Tweety"
#     email "tweety@bird.com"
#     password "puddycat"
#     password_confirmation "puddycat"
#   end
# end
