module Notifyer
  class NotificationOptOut < ActiveRecord::Base
    # Specifically define name of table
    self.table_name = :notification_opt_outs

    belongs_to :user
    belongs_to :notification
    belongs_to :notifyable, polymorphic: true

    before_save :update_atr

    def update_atr
      notif      = self.notification
      notif_id   = notif.notifyable_id
      notif_type = notif.notifyable_type
      self.notifyable_id   = notif_id
      self.notifyable_type = notif_type
    end
  end
end
