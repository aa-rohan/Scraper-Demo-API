require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Searchable concern' do
    let!(:category1) { FactoryBot.create(:category, name: 'Electronics') }
    let!(:category2) { FactoryBot.create(:category, name: 'Outdoors') }
    it 'filters categories by name' do
      expect(Category.search('elec')).to include(category1)
      expect(Category.search('elec')).not_to include(category2)
    end
  end
end
