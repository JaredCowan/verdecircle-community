class UserRelationship < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'

  has_many :activities, as: :targetable, dependent: :destroy

  before_destroy :delete_mututal_following

  aasm column: :state do
    state :pending, initial: true, before_enter: :not_blocked
    state :accepted
    state :blocked

    event :accept do
      transitions to: :accepted, after: [:send_acceptance_email, :accept_mutual_following!]
    end

    event :block do
      transitions to: :blocked, after: [:block_mutual_following!]
    end
  end

  # validate :not_blocked

  def self.request(user1, user2)
    transaction do
      followshipone = create(user: user1, follower: user2, state: 'pending')
      followshiptwo = create(user: user2, follower: user1, state: 'requested')

      # Once email methods are setup. Send requested email
      # send_request_email(followshipone) unless !followshipone.new_record?
    end
  end

  def not_blocked
    if UserRelationship.exist?(user_id: user_id, follower_id: follower_id, state: 'blocked') ||
       UserRelationship.exist?(user_id: follower_id, follower_id: user_id, state: 'blocked')
      errors.add(:base, "Sorry, you cant follow this user.")
    end
  end

  def mutual_following
    self.class.where({user_id: follower_id, follower_id: user_id}).first
  end

  def accept_mutual_following!
    mutual_following.update(state: 'accepted')
  end

  def delete_mutual_following!
    mutual_following.destroy!
  end

  def block_mutual_following!
    mutual_following.update(state: 'blocked') unless !mutual_following
  end

  # Make a send requested email method
  def send_request_email(user)
    # UserMailer.delay.send_request_email(user.id)
  end

  # Make a send accepted request email method
  def send_accepted_email(user)
    # UserMailer.delay.send_accepted_email(user.id)
  end
end
