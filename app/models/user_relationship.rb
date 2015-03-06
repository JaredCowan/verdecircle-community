class UserRelationship < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :following, class_name: 'User', foreign_key: 'follower_id'

  has_many :activities, as: :targetable, dependent: :destroy

  before_destroy :delete_mutual_following!

  aasm column: :state do
    state :following, initial: true
    state :followed
  end

  def self.request(user1, user2)
    UserRelationship.transaction do
      UserRelationship.create(user_id: user2.id, follower_id: user1.id, state: 'followed')
      UserRelationship.create(user_id: user1.id, follower_id: user2.id, state: 'following')

      # raise ActiveRecord::Rollback if user1 == user2
    end
  end

  def mutual_following
    # ToDo: Fix this so the first argument is the correct find method
    # 
    # If User one visits User two's profile and click the follow button
    # User two should be user_id and User one should be follower_id
    self.class.where({user_id: follower_id, follower_id: user_id}).first
  end

  def delete_mutual_following!
    mutual_following.delete
  end

  # Make a some kind of notification that a user has a new follower
  def send_acceptance_email
    # UserMailer.delay.send_accepted_email(user_id)
  end
end
