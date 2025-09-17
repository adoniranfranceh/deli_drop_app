require 'rails_helper'

describe 'User views category list', type: :system do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }

  it 'successfully' do
    category = create(:category, restaurant:, name: 'Pizzas')
    create(:product, category:, name: 'Pizza Margheirita', duration: 25,
                     description: 'Deliciosa pizza de queijo e tomate.', status: :active, base_price: 3590, restaurant:)
    create(:product, category:, name: 'Pizza Cream Cheese', duration: 23,
                     description: 'Deliciosa pizza de Cream Cheese.', status: :active, base_price: 3790, restaurant:)
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click

    expect(page).to have_current_path(menu_path)
    expect(page).to have_button('Nova Categoria')

    within '.products-container' do
      expect(page).to have_content('Pizza Margheirita')
      expect(page).to have_content("Deliciosa pizza de queijo e tomate.")
      expect(page).to have_content("R$ 35,90")
      expect(page).to have_content("25 min")
      expect(page).to have_css('.edit-btn', text: 'Editar')
      expect(page).to have_css('.delete-btn')

      expect(page).to have_content('Pizza Cream Cheese')
      expect(page).to have_content("Deliciosa pizza de Cream Cheese.")
      expect(page).to have_content("R$ 37,90")
      expect(page).to have_content("23 min")
      expect(page).to have_css('.edit-btn', text: 'Editar')
      expect(page).to have_css('.delete-btn')
    end
  end

  it 'but no categories' do
    restaurant
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click

    expect(page).to have_current_path(menu_path)
    expect(page).to have_button('Novo Produto')
    expect(page).to have_content('Nenhum produto encontrado')
    expect(page).to have_content('Comece adicionando seu primeiro produto')
    expect(page).to have_button('Adicionar Produtos')
  end
end
