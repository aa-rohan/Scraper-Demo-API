class Product < ApplicationRecord
  belongs_to :category
  validates :title, :price, presence: true
end
