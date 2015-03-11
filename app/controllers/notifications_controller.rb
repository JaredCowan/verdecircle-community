class NotificationsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!

  def index
    @notifications = Notifyer::Notification.find_by_sql("SELECT * FROM notifications FULL OUTER JOIN users ON notifications.user_id=users.id WHERE users.id IN ('" + current_user.id.to_s  + "')")
    @unread_count  = @notifications.map(&:is_read).reject {|n| n == true}.count
  end

  def mark_as_read
    notifId   = params[:id] unless !(params.has_key? :id)
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
    redirect_to :back
  end

  # Only here for development
  def mark_as_unread
    Notifyer::Notification.all.each do |n|
      n.update(is_read: false)
    end
    redirect_to :back
  end

  private

    def notification_params
      params.require(:notification).permit(:user_id, :sender_id, :is_read, :notifyable_id, :notifyable_type)
    end
end
