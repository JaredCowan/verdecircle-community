class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.belongs_to :user, null: false, index: true

      t.string :subject, null: false, default: ""
      t.text :body, :integer, null: false

      # Column for soft deletes
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
