require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  render_views
  describe 'GET #index' do
    let!(:product1) { FactoryBot.create(:product, title: 'Apple Iphone', description: 'Great phone') }
    let!(:product2) { FactoryBot.create(:product, title: 'Samsung Galaxy', description: 'Nice camera') }

    context 'without search and filter params' do
      it 'returns a list of products' do
        get :index, format: :json

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json_response['products'].count).to eq(2)
      end
    end

    context 'with search params' do
      it 'filters products by search query' do
        get :index, params: { search: 'Iphone' }, format: :json
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(json_response['products'].count).to eq(1)
        expect(json_response['products'][0]['title']).to eq('Apple Iphone')
      end
    end
  end

  describe 'GET #show' do
    let!(:product) { FactoryBot.create(:product) }

    it 'returns the serialized attributes of a product' do
      get :show, params: { id: product.id }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json_response['title']).to eq(product.title)
      expect(json_response['description']).to eq(product.description)
    end
  end

  describe 'POST #scrape_product' do
    let(:product) { instance_double(Product, url: 'http://www.daraz.com/product', serialized_attributes: { id: 1, url: 'http://www.daraz.com/product', title: 'Scraped Product Title' }) }
    let(:product_url) { 'https://www.daraz.com/product' }
    let(:service_instance) { instance_double(ProductScrapingService) }

    before do
      allow(Product).to receive(:find_or_create_by).and_return(product)
      allow(service_instance).to receive(:scrape)
      allow(ProductScrapingService).to receive(:new).and_return(service_instance)
    end

    it 'creates or finds the product and scrapes data' do
      post :scrape_product, params: { url: product_url }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json_response['data']['title']).to eq('Scraped Product Title')
    end
  end
end
