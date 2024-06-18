require 'rails_helper'
RSpec.describe Product, type: :model do
  describe 'methods' do
    let(:product) { FactoryBot.create(:product) }
    let(:category) { FactoryBot.create(:category, name: 'Example Category') }

    it 'calculates price amount correctly' do
      product.update(price: 'Rs. 1139')
      expect(product.price_amount).to eq(1139)
    end

    it 'returns product categories' do
      product.categories << category
      expect(product.product_categories).to include('Example Category')
    end

    it 'adds category to product' do
      product.add_category('New Category')
      expect(product.categories.pluck(:name)).to include('New Category')
    end
  end

  describe 'scopes' do
    let!(:product1) { FactoryBot.create(:product) }
    let!(:product2) { FactoryBot.create(:product) }
    let!(:category1) { FactoryBot.create(:category, name: 'Category 1') }
    let!(:category2) { FactoryBot.create(:category, name: 'Category 2') }

    before do
      product1.categories << category1
      product2.categories << category2
    end

    it 'filters products by category' do
      expect(Product.filter_by_category('Category 1')).to include(product1)
      expect(Product.filter_by_category('Category 1')).not_to include(product2)
    end
  end

  describe 'concerns' do
    describe 'searchable' do
      let!(:product1) { FactoryBot.create(:product, title: 'Apple Iphone', description: 'Great phone') }
      let!(:product2) { FactoryBot.create(:product, title: 'Samsung Galaxy', description: 'Nice camera') }
      it 'filters products by title' do
        expect(Product.search('Apple')).to include(product1)
        expect(Product.search('Apple')).not_to include(product2)
      end

      it 'filters products by description' do
        expect(Product.search('great')).to include(product1)
        expect(Product.search('great')).not_to include(product2)
      end
    end

    describe 'serializable' do
      let!(:product) do
        FactoryBot.create(:product, title: 'Test Product', price: 'Rs. 1234', description: 'A great product')
      end
      it 'defines serialized_attributes method' do
        expect(product.serialized_attributes).to eq({
                                                      title: 'Test Product',
                                                      price_amount: 1234,
                                                      description: 'A great product',
                                                      currency_unit: 'Rs. ',
                                                      id: product.id,
                                                      url: product.url,
                                                      product_categories: [],
                                                      image_url: product.image_url,
                                                      contact_info: product.contact_info
                                                    })
      end
    end
  end
end
