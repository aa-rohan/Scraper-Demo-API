require 'nokogiri'
class ProductScrapingService
  ATTRIBUTES = %w[title description price contact_info category_name].freeze

  def initialize(url)
    @url = url
  end

  def scrape
    browser = Watir::Browser.new
    browser.goto(@url)
    update_attributes = update_hash(browser)
    browser.close

    category = Category.find_or_create_by(name: update_attributes.delete(:category_name))

    category.products.create(update_attributes.merge(url: @url))
  rescue StandardError => e
    browser.close
    Rails.logger.error "Failed to scrape product data: #{e.message}"
  end

  def update_hash(browser)
    hsh = {}
    ATTRIBUTES.each do |attribute|
      attribute_class = "#{domain.upcase}_#{attribute.upcase}_SELECTOR".constantize
      raw_attribute = browser.element(css: attribute_class).wait_until(&:present?)
      hsh[attribute.to_sym] = Nokogiri::HTML(raw_attribute.inner_html).text.strip
    end
    hsh.merge({ image_url: browser.img(css: '.gallery-preview-panel__image').src })
  end

  def domain
    @_domain = begin
      uri = URI.parse(@url)
      parts = uri.host.split('.')

      parts[1]
    end
  end
end
