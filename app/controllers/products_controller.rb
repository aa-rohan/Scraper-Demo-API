class ProductsController < ApplicationController
  def index
    products = Product.all.search(%w[title description], params[:search]).then(&paginate)
    render json: products.map(&:serialized_attributes)
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
