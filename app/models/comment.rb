class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  acts_as_paranoid

  acts_as_votable
  has_paper_trail

  validates :body, presence: true, length: { minimum: 3, maximum: 100000 }
  validates :post_id, presence: true
  validates :user_id, presence: true

  # default_scope -> { order('created_at DESC') }

  has_many :replies, -> { order("replies.cached_weighted_score DESC, replies.created_at ASC") }, dependent: :destroy
  has_many :notifications, as: :notifyable,
                           class_name: "Notifyer::Notification",
                           dependent: :destroy

  has_many :votes, class_name: 'ActsAsVotable::Vote', foreign_key: 'votable_id'

  scope :votes, lambda { |post| ActsAsVotable::Vote.where("votable_type = ? AND votable_id IN (?)", 'Comment', post.comments.where("cached_votes_total > ?", 0E0.floor).ids) }

  scope :reported, lambda { ActsAsVotable::Vote.where(vote_scope: 'reported') }

end
