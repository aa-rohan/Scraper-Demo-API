FactoryBot.define do
  factory :product do
    title { 'Example Product' }
    description { 'Example product description.' }
    price { '10.00' }
    image_url { 'https://example.com/image.jpg' }
    contact_info { 'Random seller' }
    url { 'https://example.com/product' }
  end
end
