require 'rails_helper'

describe 'User views category list', type: :system do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }

  it 'successfully' do
    category = create(:category, restaurant:, name: 'Pizzas')
    create(:product, category:, status: :active, base_price: 1000, restaurant:)
    create(:product, category:, status: :inactive, base_price: 2000, restaurant:)
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click
    find('span', text: 'Categorias').click

    expect(page).to have_current_path(menu_path)
    expect(page).to have_content('Gerenciar Categorias')
    expect(page).to have_button('Nova Categoria')

    within '.categories-container' do
      expect(page).to have_content('Pizza')
      expect(page).to have_content("Produtos\n2")
      expect(page).to have_content("Ativos\n1")
      expect(page).to have_content("Preço Médio\nR$ 15,00")
      expect(page).to have_css('.edit-btn', text: 'Editar')
      expect(page).to have_css('.delete-btn')
    end
  end

  it 'but no categories' do
    restaurant
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click
    find('span', text: 'Categorias').click

    expect(page).to have_current_path(menu_path)
    expect(page).to have_content('Gerenciar Categorias')
    expect(page).to have_button('Nova Categoria')
    expect(page).to have_content('Nenhuma categoria encontrada')
    expect(page).to have_content('Comece adicionando sua primeira categoria')
    expect(page).to have_button('Adicionar Categorias')
  end
end
