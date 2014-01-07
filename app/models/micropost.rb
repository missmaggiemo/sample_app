class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> {order('created_at DESC')}
  # means that newer posts are shown before older posts, DESC stands for 'descending'
  # -> syntax creates a lambda, do be evaulated when .call ed
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
