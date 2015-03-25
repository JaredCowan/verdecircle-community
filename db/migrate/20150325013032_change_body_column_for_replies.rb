class ChangeBodyColumnForReplies < ActiveRecord::Migration
  def change
    change_column :replies, :body, :text
  end
end
