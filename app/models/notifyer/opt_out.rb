module Notifyer
  class OptOut < ActiveRecord::Base
    self.table_name = :notification_opt_outs

    belongs_to :user

  end
end
