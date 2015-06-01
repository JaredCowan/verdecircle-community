class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :inquiry, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :phone, null: false, default: ""

      t.string :subject, null: false, default: ""
      t.text :body, null: false

      t.timestamps
    end

    add_index :contacts, :inquiry
    add_index :contacts, :name
    add_index :contacts, :email
    add_index :contacts, :phone
  end
end
