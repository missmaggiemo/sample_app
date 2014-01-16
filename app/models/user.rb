class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  # allows user.destroy to destroy microposts as well as the user
  # rails infers a foreign_key relationship in the form <class>_id, like user_id in the microposts case
  
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # 'follower' isn't a class, so we need to specify foreign_key: "follower_id"
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  # need to include class so that rails doesn't look for a 'ReverseRelationships' class
  # reverse relationships-- if the DB is a table, why can't I access 'followed_id just like 'follower_id'? they're both indices of integers...
  has_many :followers, through: :reverse_relationships, source: :follower
  
  # simple validation of name
  validates :name, presence: true, length: {maximum: 50}
  
  # validation of username
  before_save {self.username.downcase!}
  validates :username, presence: true, length: {minimum: 5}, uniqueness: {case_sensitive: false}
  
  # email stuff
  before_save { self.email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+\@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # breakdown of regex: 
  # i at the end means "case insensitive", which is why we didn't have to include capital letters
  # \A matches the start of a string
  # [\w+\-.] matches at least one character, plus, hyphen, or dot
  # [a-z\d\-.] matches at least one letter, number, hyphen, or dot
  # (\.[a-z]+)* this sequence can repeat numerous times in the email address
  # \.[a-z] matches dot and then and letters
  # \z matches the end of the string
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  
  # password stuff
  has_secure_password
  # this one line enables all the password stuff-- :password is entered by user, encrypted password is saved in DB and matched with user's password each time they enter their password
  # are the only passwords that go through the program are encrypted? where's the encryption algorithm? is there a standard algorithm? I hope it's randomized.
  validates :password, length: {minimum: 6}
  
  # authorization stuff
  before_create :create_remember_token
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  
  # feed and follow/following
  def feed
    # Micropost.where("user_id = ?", id) # microposts
    # the ? helps savoid SQL injection-- id should be properly escaped before being injected into SQL statements
    Micropost.from_users_followed_by(self)
  end
  
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
    # same as self.relationships.find_by(followed_id: other_user)
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end
  
  
  # private methods
  
  private
  
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
  
end
