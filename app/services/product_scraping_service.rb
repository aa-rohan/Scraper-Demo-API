require 'nokogiri'
class ProductScraper
  def initialize(url)
    @url = url
  end

  def scrape
    browser = Watir::Browser.new
    browser.goto(@url)

    raw_title = browser.element(css: 'placeholder').wait_until(&:present?)
    raw_description = browser.element(css: 'placeholder').wait_until(&:present?)
    raw_price = browser.element(css: 'placeholder').wait_until(&:present?)
    raw_image_url = browser.element(css: 'placeholder').wait_until(&:present?)
    raw_contact_info = browser.element(css: 'placeholder').wait_until(&:present?)
    raw_category_name = browser.element(css: 'placeholder').wait_until(&:present?)

    title = Nokogiri::HTML(raw_title.inner_html).text.strip
    description = Nokogiri::HTML(raw_description.inner_html).text.strip
    price = Nokogiri::HTML(raw_price.inner_html).text.strip
    image_url = Nokogiri::HTML(raw_image_url.inner_html).text.strip
    contact_info = Nokogiri::HTML(raw_contact_info.inner_html).text.strip
    category_name = Nokogiri::HTML(raw_category_name.inner_html).text.strip

    category = Category.find_or_create_by(name: category_name)

    category.products.create(
      title: title,
      description: description,
      price: price,
      image_url: image_url,
      contact_info: contact_info
    )
    browser.close
  rescue StandardError => e
    Rails.logger.erro "Failed to scrape product data: #{e.message}"
  end
end
