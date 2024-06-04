class AddUniqueIndexToCategorizations < ActiveRecord::Migration[7.1]
  def change
    add_index :categorizations, [:product_id, :category_id], unique: true
  end
end
