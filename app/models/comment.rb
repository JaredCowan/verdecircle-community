class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  acts_as_paranoid

  acts_as_votable

  has_paper_trail

  validates :body, presence: true
  validates :post_id, presence: true
  validates :user_id, presence: true

  default_scope -> { order('created_at ASC') }

  has_many :votes, class_name: 'ActsAsVotable::Vote', foreign_key: 'votable_id'
end
