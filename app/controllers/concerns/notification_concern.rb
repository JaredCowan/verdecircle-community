module NotificationConcern
  extend ActiveSupport::Concern

  included do
      before_action :mark_notification_read_on_show_page, only: [:show]
      # after_action :like_comment, only: [:liked]
      # after_action :unlike_comment, only: [:unliked]
  end

  def mark_notification_read_on_show_page
    if current_user
      notifId   = params[:id].split("-")[0].to_i
      notifType = params[:controller].capitalize.singularize.to_s
      userNotif = current_user.notifications.unread

      if notifId.present?
        userNotif.each do |n|
          if n.user_id == current_user.id && n.notifyable_id == notifId && n.notifyable_type == "#{notifType}"
            n.update(is_read: true)
          end
        end
      end
    end
  end # End mark_as_notification_read_on_show_page

  def like_comment
    if params[:action] == "liked"
      Notifyer::Notification.notify_user(current_user, @comment, "liked")
    end
  end

  def unlike_comment
    if params[:action] == "liked"
      notification = Notifyer::Notification.where("sender_id = ? AND notifyable_id = ? AND notifyable_type = ? AND action = ?", current_user.id.to_i, @comment.post.id.to_i, "Post", "liked").first

      if notification
        notification.destroy
      end
      # 10.times { puts params }
    end
  end
end
