require 'nokogiri'
class ProductScrapingService
  ATTRIBUTES = %w[title description price contact_info].freeze

  def initialize(url)
    @url = url
    @browser = Watir::Browser.new
  end

  def scrape
    @browser.goto(@url)
    product = Product.create(scraped_data.merge(url: @url))
    assing_categories(product)
    @browser.close
    product
  rescue StandardError => e
    Rails.logger.error "Failed to scrape product data: #{e.message}"
  ensure
    @browser.close
  end

  private

  def scraped_data
    ATTRIBUTES.each_with_object({}) do |attribute, hash|
      attribute_class = "#{domain.upcase}_#{attribute.upcase}_SELECTOR".constantize
      raw_attribute = @browser.element(css: attribute_class).wait_until(timeout: 10, &:present?)
      hash[attribute.to_sym] = Nokogiri::HTML(raw_attribute.inner_html).text.strip
    rescue Watir::Wait::TimeoutError
      hash[attribute.to_sym] = nil
    end.merge(image_url: @browser.img(css: "#{domain.upcase}_IMAGE_URL_SELECTOR".constantize).src)
  end

  def assing_categories(product)
    category_class = "#{domain.upcase}_CATEGORY_NAME_SELECTOR".constantize
    raw_category_names = @browser.elements(css: category_class).wait_until(&:present?)
    raw_category_names[1...-1].each do |raw_name|
      category_name = Nokogiri::HTML(raw_name.inner_html).text.strip
      category = Category.find_or_create_by(name: category_name)
      product.categories << category
    end
  end

  def domain
    @_domain ||= URI.parse(@url).host.split('.')[1]
  end
end
