class ProductsController < ApplicationController
  def scrape_product
    url = params[:url]
    product = Product.find_or_create_by(url: url)
    ProductScrapingService.new(product).scrape
    render json: { data: product }
  rescue StandardError => e
    render json: { error_message: e.message }, status: :unprocessable_entity
  end
end
