class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :in_reply_to, class_name: "User"
  
  before_save :extract_in_reply_to
  @@reply_regex = /\@[\w+\-.]+/
  
  default_scope -> {order('created_at DESC')}
  # means that newer posts are shown before older posts, DESC stands for 'descending'
  # -> syntax creates a lambda, do be evaulated when .call ed
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
    # SELECT * FROM microposts WHERE user_id IN (SELECT followed_id FROM relationships WHERE follower_id = 1) OR user_id = 1
  end
  
  def self.from_users_followed_by_including_replies(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_reply_to_id = :user_id", user_id: user.id)
  end
  
  private
  
  def extract_in_reply_to
    if match = @@reply_regex.match(content) # downcase can't be here because if this is nil, downcase method raises an error
      user = User.find_by(username: match.to_s.downcase[1..-1])
      self.in_reply_to = user if user
    end
    # why does this work when I haven't specified how rails should find in_reply_to_id-- I just specified in_reply_to
  end
  
end
