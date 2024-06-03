require 'nokogiri'
class ProductScrapingService
  ATTRIBUTES = %w[title description price contact_info].freeze

  def initialize(url)
    @url = url
  end

  def scrape
    @browser = Watir::Browser.new
    @browser.goto(@url)
    product = Product.create(update_hash.merge(url: @url))
    assign_product_to_categories(product)
    @browser.close
    product
  rescue StandardError => e
    @browser.close
    Rails.logger.error "Failed to scrape product data: #{e.message}"
  end

  def update_hash
    hsh = {}
    ATTRIBUTES.each do |attribute|
      attribute_class = "#{domain.upcase}_#{attribute.upcase}_SELECTOR".constantize
      raw_attribute = @browser.element(css: attribute_class).wait_until(&:present?)
      hsh[attribute.to_sym] = Nokogiri::HTML(raw_attribute.inner_html).text.strip
    end
    hsh.merge({ image_url: @browser.img(css: "#{domain.upcase}_IMAGE_URL_SELECTOR".constantize).src })
  end

  def assign_product_to_categories(product)
    category_class = "#{domain.upcase}_CATEGORY_NAME_SELECTOR".constantize
    raw_category_names = @browser.elements(css: category_class).wait_until(&:present?)
    raw_category_names[1...-1].each do |raw_name|
      category_name = Nokogiri::HTML(raw_name.inner_html).text.strip
      category = Category.find_or_create_by(name: category_name)
      product.categories << category
    end
  end

  def domain
    @_domain = begin
      uri = URI.parse(@url)
      parts = uri.host.split('.')

      parts[1]
    end
  end
end
