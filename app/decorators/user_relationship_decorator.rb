class UserRelationshipDecorator < ApplicationDecorator
  decorates :user_relationship
  delegate_all

  def friendship_state
    model.state.titleize
  end

  def sub_message
    case model.state
    when 'pending'
      "Friend request pending."
    when 'accepted'
      "You are friends with #{model.friend.full_name}."
    end
  end

  def update_action_verbiage
    case model.state
    when 'pending'
      'Update Request'
    when 'requested'
      'Accept Request'
    when 'accepted'
      'Update Friendship'
    when 'blocked'
      'Unblock Friend'
    end
  end

  def update_class
    case model.state
    when 'pending'
      'default'
    when 'requested'
      'success'
    when 'accepted'
      'success'
    when 'blocked'
      'alert'
    end
  end

  def update_label
    case model.state
    when 'pending'
      'warning'
    when 'requested'
      'warning'
    when 'accepted'
      'success'
    when 'blocked'
      'alert'
    end
  end

  def update_state
    case model.state
    when 'pending'
      'Friendship Pending'
    when 'requested'
      'Friendship Requested'
    when 'accepted'
      'Friends'
    when 'blocked'
      'Blocked'
    end
  end

  def relationship_header
    case model.state
    when 'pending'
      "Pending Friendship With #{model.friend.full_name}"
    when 'requested'
      "Requested Friendship With #{model.friend.full_name}"
    when 'accepted'
      "Viewing Friendship With <br> #{model.friend.full_name}"
    when 'blocked'
      "You have blocked #{model.friend.full_name}"
    end
  end
end
