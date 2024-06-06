class ProductUpdateWorker
  include Sidekiq::Worker

  def perform(product_id)
    product = Product.find_by(id: product_id)
    return unless product

    ProductScrapingService.new(product).scrape
  end
end
