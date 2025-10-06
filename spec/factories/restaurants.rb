FactoryBot.define do
  factory :restaurant do
    name { "Ração de humanos" }
    culinary_style { 'brazilian' }
    description { "Venha comer na casa de ração para humanos" }
    image { "http://imagem.com" }
    phone { "89 99999-9999" }
    address { "Rua das Palmeiras, 400" }
    restaurant_user { nil }
  end
end
