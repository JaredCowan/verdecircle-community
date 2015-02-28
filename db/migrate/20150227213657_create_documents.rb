class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.belongs_to :post, index: true

      t.timestamps
    end

    add_attachment :documents, :attachment
  end
end
