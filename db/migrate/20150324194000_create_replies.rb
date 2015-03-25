class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :body, null: false, default: ''

      t.belongs_to :user, null: false, index: true
      t.belongs_to :comment, null: false, index: true

      t.timestamps
      t.datetime :deleted_at

      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0
      t.integer :cached_weighted_score, default: 0
      t.integer :cached_weighted_total, default: 0
      t.float :cached_weighted_average, default: 0.0

    end

    add_index :replies, :deleted_at

    add_index  :replies, :cached_votes_total
    add_index  :replies, :cached_votes_score
    add_index  :replies, :cached_votes_up
    add_index  :replies, :cached_votes_down
    add_index  :replies, :cached_weighted_score
    add_index  :replies, :cached_weighted_total
    add_index  :replies, :cached_weighted_average
  end
end
