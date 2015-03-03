class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  acts_as_votable

  validates :body, presence: true
  validates :post_id, presence: true
  validates :user_id, presence: true

  default_scope -> { order('created_at ASC') }
end
