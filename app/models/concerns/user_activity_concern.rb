module Concerns::UserActivityConcern
  extend ActiveSupport::Concern
  
  def create_activity(item, action)
    activity            = activities.new
    activity.targetable = item
    activity.action     = action
    activity.save
    activity
  end

  def destroy_activity(object, action_type)
    Activity.find_by(targetable_id: object.id, action: "#{action_type}").destroy!
    puts caller[0][/`([^']*)'/, 1]
  end
end
