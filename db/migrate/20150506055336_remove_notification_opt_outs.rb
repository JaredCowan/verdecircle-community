class RemoveNotificationOptOuts < ActiveRecord::Migration
  def change
    drop_table :notification_opt_outs
  end
end
