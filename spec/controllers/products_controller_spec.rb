# require 'rails_helper'

# RSpec.describe ProductsController, type: :controller do
#   describe 'GET #index' do
#     let!(:product1) { FactoryBot.create(:product, title: 'Apple Iphone', description: 'Great phone') }
#     let!(:product2) { FactoryBot.create(:product, title: 'Samsung Galaxy', description: 'Nice camera') }

#     context 'without search and filter params' do
#       it 'returns a list of products' do
#         get :index, format: :json
#         expect(response).to have_http_status(:success)
#         expect(json_response['products'].count).to eq(2)
#       end
#     end

#     context 'with search params' do
#       it 'filters products by search query' do
#         get :index, params: { search: 'Iphone' }, format: :json
#         expect(response).to have_http_status(:success)
#         expect(json_response['products'].count).to eq(1)
#         expect(json_response['products'][0]['title']).to eq('Apple Iphone')
#       end
#     end
#   end

#   describe 'GET #show' do
#     let!(:product) { FactoryBot.create(:product) }

#     it 'returns the serialized attributes of a product' do
#       get :show, params: { id: product.id }
#       expect(response).to have_http_status(:success)
#       expect(json_response['title']).to eq(product.title)
#       expect(json_response['description']).to eq(product.description)
#     end
#   end

#   describe 'POST #scrape_product' do
#     let(:product_url) { 'https://example.com/product' }
#     it 'creates or finds the product and scrapes data' do
#       post :scrape_product, params: { url: product_url }
#       expect(response).to have_http_status(:success)
#       expect(json_response['data']['title']).to eq('Scraped Product Title')
#     end
#   end
# end
