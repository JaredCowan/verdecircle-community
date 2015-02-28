class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id, index: true
      t.string :action, null: false, default: ''

      t.integer :targetable_id, null: false, default: ''
      t.string  :targetable_type, null: false, default: ''

      t.timestamps
    end

    add_index :activities, [:targetable_id, :targetable_type]
  end
end
