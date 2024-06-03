class RemoveCategoryIdFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_reference :products, :category, index: true, null: false, foreign_key: true
  end
end
