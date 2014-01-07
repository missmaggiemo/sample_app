# this creates the rake task db:populate
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Bugs", email: "Bugs@bunny.com", password: "whatsupdoc", password_confirmation: "whatsupdoc")
    99.times do |n|
      name = Faker::Name.name
      email = "bunny-#{n+1}@toons.com"
      password = "looneytoons"
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each {|user| user.microposts.create(content: content)}
    end
  end
end