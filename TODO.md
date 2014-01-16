# TODO

Add a Javascript display to the Home page to count down from 140 charcters for each micropost.

What in the hell is that .js.erb thing that I just wrote? Why the $? How does that work?

What's the deal with the SQL in "Microposts.from_users_followed_by"? Here's the full function:

def self.from_users_followed_by(user)
  followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
  where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
end



# Extensions

unique IDs

@reply

messaging

follower notifications

password reminders-- and password hiding!

signup confirmation email?

RSS feed

REST API

Search

