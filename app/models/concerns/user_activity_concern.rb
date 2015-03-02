module Concerns::UserActivityConcern
  extend ActiveSupport::Concern

  def create_activity(item, action)
    activity            = activities.new
    activity.targetable = item
    activity.action     = action
    activity.save
    activity
    # a = activity
    # u = User.find(a.user_id)
    
    # Save for future feature of push notifications
    # data = {
    #   id: a.id, user_id: a.user_id, action: a.action,
    #   targetable_id: a.targetable_id, targetable_type: a.targetable_type,
    #   created_at: a.updated_at, updated_at: a.updated_at, userdata: u.username
    # }
    # Pusher['notifications'].trigger('activity', data)
  end

  def destroy_activity(object, action_type)
    Activity.find_by(targetable_id: object.id, action: "#{action_type}").destroy!
    puts caller[0][/`([^']*)'/, 1]
  end
end
