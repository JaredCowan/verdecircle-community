class UserRelationship < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'

  has_many :activities, as: :targetable, dependent: :destroy

  before_destroy :delete_mutual_following!

  aasm column: :state do
    state :pending, initial: true
    state :requested
    state :accepted
    state :blocked

    event :accept do
      # Transition any state
      transitions to: :accepted, after: [:send_acceptance_email, :accept_mutual_following!]
    end

    event :block do
      # Transition any state
      transitions to: :blocked, after: [:block_mutual_following!]
    end
  end

  validate :not_blocked

  def self.request(user1, user2)
    UserRelationship.transaction do
      UserRelationship.create(user_id: user1.id, follower_id: user2.id, state: 'pending')
      UserRelationship.create(user_id: user2.id, follower_id: user1.id, state: 'requested')

      raise ActiveRecord::Rollback if user1 == user2

      if UserRelationship.where(user_id: user1.id, follower_id: user2.id).count > 1 ||
         UserRelationship.where(user_id: user2.id, follower_id: user1.id).count > 1
        raise ActiveRecord::Rollback
      end
    end
  end
      # Once email methods are setup. Send requested email
      # send_request_email(followshipone) unless !followshipone.new_record?

  def not_blocked
    if UserRelationship.where(user_id: user_id, follower_id: follower_id, state: 'blocked').present? ||
       UserRelationship.where(user_id: follower_id, follower_id: user_id, state: 'blocked').present?
      raise ActiveRecord::Rollback
    end
  end

  # def not_self
  #   if user_id == follower_id
  #     return false
  #     # raise ActiveRecord::Rollback, "Call tech support!"
  #   end
  # end

  def mutual_following
    # ToDo: Fix this so the first argument is the correct find method
    # 
    # If User one visits User two's profile and click the follow button
    # User two should be user_id and User one should be follower_id
    # self.class.where({user_id: follower_id, follower_id: user_id}).first
    self.class.where({user_id: user_id, follower_id: follower_id}).first
  end

  def accept_mutual_following!
    mutual_following.update(state: 'accepted')
  end

  def delete_mutual_following!
    mutual_following.delete
  end

  def block_mutual_following!
    mutual_following.update(state: 'blocked') unless !mutual_following
    self.class.where({user_id: follower_id, follower_id: user_id}).destroy!
  end

  # Make a send requested email method
  def send_request_email(user)
    # UserMailer.delay.send_request_email(user_id)
  end

  # Make a send accepted request email method
  def send_acceptance_email
    puts user_id
    puts follower_id
    # UserMailer.delay.send_accepted_email(user_id)
  end
end
