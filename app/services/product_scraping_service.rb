require 'nokogiri'
class ProductScrapingService
  ATTRIBUTES = %w[title description price contact_info].freeze
  MAX_PAGE_LOAD_TIME = 20

  def initialize(product)
    @product = product
    @browser = Watir::Browser.new
  end

  def scrape
    @browser.driver.manage.timeouts.page_load = MAX_PAGE_LOAD_TIME
    @browser.goto(@product.url)
    update_product
  rescue Selenium::WebDriver::Error::TimeoutError
    update_product
  ensure
    @browser.close
  end

  private

  def update_product
    @product.update(scraped_data)
    assign_categories
  end

  def scraped_data
    ATTRIBUTES.each_with_object({}) do |attribute, hash|
      attribute_class = "#{domain.upcase}_#{attribute.upcase}_SELECTOR".constantize
      raw_attribute = @browser.element(css: attribute_class).wait_until(timeout: 10, &:present?)
      hash[attribute.to_sym] = Nokogiri::HTML(raw_attribute.inner_html).text.strip
    rescue Watir::Wait::TimeoutError
      hash[attribute.to_sym] = nil
    end.merge(image_url: @browser.img(css: "#{domain.upcase}_IMAGE_URL_SELECTOR".constantize).src)
  end

  def assign_categories
    category_class = "#{domain.upcase}_CATEGORY_NAME_SELECTOR".constantize
    raw_category_names = @browser.elements(css: category_class).wait_until(&:present?)
    raw_category_names[1...-1].each do |raw_name|
      category_name = Nokogiri::HTML(raw_name.inner_html).text.strip
      @product.add_category(category_name)
    end
  end

  def domain
    @_domain ||= URI.parse(@product.url).host.split('.')[1]
  end
end
