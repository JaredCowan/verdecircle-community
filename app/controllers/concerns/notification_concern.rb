module NotificationConcern
  extend ActiveSupport::Concern

  included do
    before_action :mark_notification_read_on_show_page, only: [:show]
  end

  def mark_notification_read_on_show_page
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
  end # End mark_as_notification_read_on_show_page
end
