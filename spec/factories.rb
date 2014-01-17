FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Person #{n}"}
    sequence(:email) {|n| "person_#{n}@example.com"}
    sequence(:username) {|n| "Person_#{n}"}
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
    
    factory :reply do
      sequence(:content) {|n| "@person_#{n} spam spam spam!"}
    end
    
  end
  # factory for micropost
end

