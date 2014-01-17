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
    admin = User.create!(name: "Bugs Bunny", email: "Bugs@bunny.com", username: "bugsbunny", password: "whatsupdoc", password_confirmation: "whatsupdoc", admin: true)
    non_admin = User.create!(name: "Elmer Fudd", email: "Elmer@fudd.com", username: "bunnyhunter", password: "huntingwabbits", password_confirmation: "huntingwabbits")
    99.times do |n|
      name = Faker::Name.name
      username = name.scan(/\w+/).join
      email = "bunny-#{n+1}@toons.com"
      password = "looneytoons"
      User.create!(name: name, email: email, username: username, password: password, password_confirmation: password)
    end
  end
    
    # creates fake posts
  def make_microposts
    users = User.all(limit: 6)
    40.times do
      content = Faker::Lorem.sentence(5)
      users.each {|user| user.microposts.create(content: content)}
    end
    10.times do |i|
      content = "Spam spam spam!"
      users.each {|user| user.microposts.create(content: "@#{User.find(i+1).username} #{content}")}
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
  
