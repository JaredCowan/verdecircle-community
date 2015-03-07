class CreateNotificationOptOuts < ActiveRecord::Migration
  def change
    create_table :notification_opt_outs do |t|
      t.references :unsubscriber, polymorphic: true
      t.references :notification

      t.timestamps
    end

    add_index :notification_opt_outs, [:unsubscriber_id, :unsubscriber_type],
      name: 'index_notification_opt_outs_on_unsubscriber_id_type'
  end
end