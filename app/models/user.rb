class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+\@[a-z\d\-.]+\.[a-z]+\z/i
  # breakdown of regex: 
  # i at the end means "case insensitive", which is why we didn't have to include capital letters
  # \A matches the start of a string
  # [\w+\-.] matches at least one character, plus, hyphen, or dot
  # [a-z\d\-.] matches at least one letter, number, hyphen, or dot
  # \.[a-z] matches dot and then and letters
  # \z matches the end of the string
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  
  has_secure_password
  # this one line enables all the password stuff-- :password is entered by user, encrypted password is saved in DB and matched with user's password each time they enter their password
  # are the only passwords that go through the program are encrypted? where's the encryption algorithm? is there a standard algorithm? I hope it's randomized.
  validates :password, length: {minimum: 6}
  
end
