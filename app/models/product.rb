class Product < ApplicationRecord
  include Serializable
  include Searchable

  searchable_fields :title, :description

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  validates :title, :price, presence: true

  serialize :id, :title, :description, :image_url, :contact_info, :url, :price_amount, :product_categories, :currency_unit

  scope :filter_by_category, lambda { |category_name|
    joins(:categories).where(categories: { name: category_name })
  }

  def add_category(category_name)
    category = Category.find_or_create_by(name: category_name)
    categories << category unless categories.exists?(category.id)
  end

  def price_amount
    amount = price.scan(/\d/).join
    amount.to_i
  end

  def currency_unit
    unit = price.match(/^[^\d]*/)
    unit ? unit[0] : ''
  end

  def product_categories
    categories.pluck(:name).uniq
  end
end
