class NotificationsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  respond_to :html, :json, :js

  def index
    @notifications = current_user.notifications
  end

  def mark_as_read
    notifId = params[:id] if params.has_key? :id
    userNotif = current_user.notifications.unread

    if notifId.present?
      userNotif.find(notifId).update(is_read: true)
    else
      userNotif.each do |n|
        n.update(is_read: true)
      end
    end
    redirect_to :back
  end

  def opt_out
    objectId   = params[:id].to_i
    objectType = params[:type].to_s

    Notifyer::OptOut.create(user_id: current_user.id, notifyable_id: objectId, notifyable_type: objectType)
    # 10.times { puts params }
    redirect_to :back
  end

  # Only here for development
  def mark_as_unread
    Notifyer::Notification.all.each do |n|
      n.update(is_read: false)
    end
    redirect_to :back
  end
end
