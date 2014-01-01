class User < ActiveRecord::Base
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
  
end
