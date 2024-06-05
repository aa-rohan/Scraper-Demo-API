class Category < ApplicationRecord
  include Searchable

  searchable_fields :name

  has_many :categorizations, dependent: :destroy
  has_many :products, through: :categorizations
  validates :name, presence: true, uniqueness: true
end
