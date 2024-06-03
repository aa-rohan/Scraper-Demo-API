require 'nokogiri'
class ProductScrapingService
  def initialize(url)
    @url = url
  end

  def scrape
    browser = Watir::Browser.new
    browser.goto(@url)

    raw_title = browser.element(css: '.pdp-mod-product-badge-title').wait_until(&:present?)
    raw_description = browser.element(css: '.pdp-product-highlights').wait_until(&:present?)
    raw_price = browser.element(css: '.pdp-price').wait_until(&:present?)
    raw_image_url = browser.img(css: '.gallery-preview-panel__image')
    raw_contact_info = browser.element(css: '.seller-name__detail-name').wait_until(&:present?)
    raw_category_name = browser.elements(css: '.breadcrumb_item_anchor').first.wait_until(&:present?)

    title = Nokogiri::HTML(raw_title.inner_html).text.strip
    description = Nokogiri::HTML(raw_description.inner_html).text.strip
    price = Nokogiri::HTML(raw_price.inner_html).text.strip
    image_url = raw_image_url.src
    contact_info = Nokogiri::HTML(raw_contact_info.inner_html).text.strip
    category_name = Nokogiri::HTML(raw_category_name.inner_html).text.strip

    category = Category.find_or_create_by(name: category_name)

    browser.close

    category.products.create(
      title: title,
      description: description,
      price: price,
      image_url: image_url,
      contact_info: contact_info
    )
  rescue StandardError => e
    browser.close
    Rails.logger.error "Failed to scrape product data: #{e.message}"
  end
end
