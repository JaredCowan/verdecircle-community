class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false

      t.belongs_to :user, index: true
      t.belongs_to :post, index: true

      t.timestamps
    end
    add_index :comments, [:created_at]
  end
end
