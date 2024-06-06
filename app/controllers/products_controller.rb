class ProductsController < ApplicationController
  include Filterable
  def index
    products = Product.all
    products = products.search(params[:search]) if params[:search]
    products = filter(products)
    total_pages = (products.count / per_page.to_f).ceil
    products = products.then(&paginate) if products.present?
    render json: { products: products.map(&:serialized_attributes), total_pages: total_pages }
  end

  def show
    product = Product.find(params[:id])
    render json: product.serialized_attributes
  end

  def scrape_product
    url = params[:url]
    product = Product.find_or_create_by(url: url)
    ProductScrapingService.new(product).scrape
    render json: { data: product.serialized_attributes }
  rescue StandardError => e
    render json: { error_message: e.message }, status: :unprocessable_entity
  end
end
