FactoryBot.define do
  factory :product do
    title { 'Example Product' }
    description { 'Example product description.' }
    price { '10.00' }
    image_url { 'https://www.daraz.com/image.jpg' }
    contact_info { 'Random seller' }
    url { 'https://www.daraz.com/product' }
  end
end
