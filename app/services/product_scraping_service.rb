require 'nokogiri'
require 'open-url'

class ProductScraper
  def initialize(url)
    @url = url
  end

  def scrape
    doc = Nokogiri::HTML(URI.open(@url))

    title = doc.css('placeholer').text.strip
    description = doc.css('placeholer').text.strip
    price = doc.css('placeholer').text.strip
    image_url = doc.css('placeholer').text.strip
    contact_info = doc.css('placeholer').text.strip
    category_name = doc.css('placeholer').text.strip

    category = Category.find_or_create_by(name: category_name)

    category.products.create(
      title: title,
      description: description,
      price: price,
      image_url: image_url,
      contact_info: contact_info
    )
  rescue StandardError => e
    Rails.logger.erro "Failed to scrape product data: #{e.message}"
  end
end
