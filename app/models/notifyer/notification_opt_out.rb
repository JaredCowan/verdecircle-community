module Notifyer
  class NotificationOptOut < ActiveRecord::Base
    # Specifically define name of table
    self.table_name = :notification_opt_outs

    belongs_to :user
    belongs_to :notifyable, polymorphic: true
  end
end
