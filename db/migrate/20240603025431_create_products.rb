class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :image_url
      t.string :contact_info
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
