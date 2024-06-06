FactoryBot.define do
  factory :categorization do
    association :product
    association :category
  end
end
