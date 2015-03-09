class CreateNotificationOptOuts < ActiveRecord::Migration
  def change
    create_table :notification_opt_outs do |t|
      t.integer :user_id, null: false, default: ''

      t.integer :notifyable_id, null: false, default: ''
      t.string  :notifyable_type, null: false, default: ''

      t.timestamps
    end

    add_index :notification_opt_outs, :user_id

    # Define index name as auto-generated one is too long & exceeds 63 character limit
    add_index :notification_opt_outs, [:notifyable_id, :notifyable_type],
      name: 'index_notification_opt_outs_on_notifyable_id_type'
  end
end