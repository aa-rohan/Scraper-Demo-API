class ChangePriceToStringAndAddUrlToProducts < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :price, :string

    add_column :products, :url, :string
  end
end
