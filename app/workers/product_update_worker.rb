class ProductUpdateWorker
  include Sidekiq::Worker

  def perform
    old_products = Product.where('updated_at < ?', 1.week.ago)

    old_products.each do |product|
      ProductScrapingService.new(product).scrape
    end
  end
end
