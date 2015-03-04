class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name, default: "", null: false

      t.timestamps
    end
    add_column :posts, :topic_id, :integer, default: "", null: false

    add_index :topics, :name
    add_index :posts, :topic_id
  end
end
