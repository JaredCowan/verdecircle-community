class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :user, index: true

      t.string :subject, null: false, default: ''
      t.text :body, null: false, default: ''

      t.timestamps
    end
  end
end