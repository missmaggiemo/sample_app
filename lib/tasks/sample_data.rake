namespace :db do
  desc "Fill database with sample data"
  
  # this creates the rake task db:populate
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
  
  # this creates fake users
  def make_users
    admin = User.create!(name: "Bugs Bunny", email: "Bugs@bunny.com", password: "whatsupdoc", password_confirmation: "whatsupdoc", admin: true)
    non_admin = User.create!(name: "Elmer Fudd", email: "Elmer@fudd.com", password: "huntingwabbits", password_confirmation: "huntingwabbits")
    99.times do |n|
      name = Faker::Name.name
      email = "bunny-#{n+1}@toons.com"
      password = "looneytoons"
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
  end
    
    # creates fake posts
  def make_microposts
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each {|user| user.microposts.create(content: content)}
    end
  end
  
  # create several follower-followed relationships
  def make_relationships
    users = User.all
    user = users.first
    followed_users = users[1..49]
    followers = users[2..39]
    followed_users.each {|followed| user.follow!(followed)}
    followers.each {|follower| follower.follow!(user)}
  end
  
end
  
#   task populate: :environment do
#     admin = User.create!(name: "Bugs", email: "Bugs@bunny.com", password: "whatsupdoc", password_confirmation: "whatsupdoc")
#     99.times do |n|
#       name = Faker::Name.name
#       email = "bunny-#{n+1}@toons.com"
#       password = "looneytoons"
#       User.create!(name: name, email: email, password: password, password_confirmation: password)
#     end
#     
#     # creates fake posts
#     users = User.all(limit: 6)
#     50.times do
#       content = Faker::Lorem.sentence(5)
#       users.each {|user| user.microposts.create(content: content)}
#     end
#   end
#   
#   
# end