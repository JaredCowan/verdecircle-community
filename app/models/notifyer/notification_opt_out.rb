module Notifyer
  class NotificationOptOut < ActiveRecord::Base
    # Specifically define name of table
    self.table_name = :notification_opt_outs

    belongs_to :user

  end
end
