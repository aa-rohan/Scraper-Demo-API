require 'rails_helper'

RSpec.describe ProductScrapingService do
  let!(:product) { FactoryBot.create(:product, title: 'Apple Iphone', description: 'Great phone') }
  let(:browser) { instance_double(Watir::Browser) }
  let(:service) { described_class.new(product) }
  let(:page_html) do
    '<html><body><div class="title">Product Title</div><div class="description">Product Description</div><div class="price">$100</div><div class="contact_info">Contact Info</div><img class="image_url" src="http://example.com/image.jpg"/><div class="category_name">Category1</div><div class="category_name">Category2</div></body></html>'
  end

  before do
    allow(Watir::Browser).to receive(:new).and_return(browser)
    allow(browser).to receive(:driver).and_return(double('driver',
                                                         manage: double('manage',
                                                                        timeouts: double('timeouts', page_load: nil))))
    allow(browser).to receive(:goto)
    allow(browser).to receive(:close)
    allow(browser).to receive(:element).and_return(double('element',
                                                          wait_until: double('element', present?: true,
                                                                                        inner_html: 'Content')))
    allow(browser).to receive(:elements).and_return([
                                                      double('element',
                                                             inner_html: '<div class="category_name">Category1</div>'), double('element', inner_html: '<div class="category_name">Category2</div>'), double('element',
                                                                wait_until: double('element', present?: true,
                                                                                              inner_html: 'Content'))
                                                    ])
    allow(browser).to receive(:img).and_return(double('img', src: 'http://example.com/image.jpg'))
    allow(Nokogiri::HTML::Document).to receive(:parse).and_return(Nokogiri::HTML(page_html))
  end

  describe '#scrape' do
    context 'when page loads successfully' do
      before do
        allow(browser.driver.manage.timeouts).to receive(:page_load=)
        allow(service).to receive(:update_product)
      end

      it 'navigates to the product URL' do
        service.scrape
        expect(browser).to have_received(:goto).with(product.url)
      end

      it 'updates the product' do
        service.scrape
        expect(service).to have_received(:update_product)
      end
    end

    context 'when a timeout error occurs' do
      before do
        allow(browser.driver.manage.timeouts).to receive(:page_load=)
        allow(browser).to receive(:goto).and_raise(Selenium::WebDriver::Error::TimeoutError)
        allow(service).to receive(:update_product)
      end

      it 'rescues the timeout error and updates the product' do
        service.scrape
        expect(service).to have_received(:update_product)
      end
    end
  end
end
