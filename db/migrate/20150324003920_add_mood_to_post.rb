class AddMoodToPost < ActiveRecord::Migration
  def change
    add_column :posts, :mood, :string, default: ""
  end
end
