class Product < ApplicationRecord
  include Serializable

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  validates :title, :price, presence: true

  serialize :id, :title, :description, :image_url, :contact_info, :url, :price_amount, :product_categories

  def add_category(category_name)
    category = Category.find_or_create_by(name: category_name)
    categories << category unless categories.exists?(category.id)
  end

  def price_amount
    amount = price.scan(/\d/).join
    amount.to_i
  end

  def product_categories
    categories.pluck(:name).uniq
  end
end
