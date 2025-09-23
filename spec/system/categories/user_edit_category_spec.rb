require 'rails_helper'

describe 'User creates a category', type: :system do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:category) { create(:category, restaurant:, name: 'Pizza', description: 'Categorias de pizzas diversas') }

  before do
    restaurant
    category
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click
    find('span', text: 'Categorias').click
    within find('.category-card', text: 'Pizza') do
      click_button 'Editar'
    end
  end

  it 'successfully' do
    fill_in 'Nome', with: 'Pizzas'
    fill_in 'Descrição', with: 'Categorias de pizzas diversas do nosso restaurante'
    click_button 'Salvar'

    expect(page).to have_content('Categoria atualizada com sucesso!')
    expect(page).not_to have_css('.modal-content', visible: true)
    expect(page).to have_current_path(menu_path)
    find('span', text: 'Categorias').click
    expect(page).to have_content('Pizzas')
    expect(Category.last.name).to eq('Pizzas')
    expect(Category.last.description).to eq('Categorias de pizzas diversas do nosso restaurante')
    expect(Category.last.restaurant).to eq(user.restaurant)
  end

  it 'and see errors in all required fields after touched' do
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Nome', with: ''

    expect(page).to have_current_path(menu_path)
    expect(page).to have_css('.modal-content', visible: true)
    expect(page).to have_content("Nome da categoria é obrigatório")
    expect(page).not_to have_content("Descrição não pode ficar em branco")
    expect(page).to have_button('Salvar', disabled: true)
  end

  it 'and sees an error message if something goes wrong on the server' do
    allow_any_instance_of(Category).to receive(:update).and_return(false)
    allow_any_instance_of(Category).to receive_message_chain(:errors, :full_messages)
                                      .and_return([ "Erro interno no servidor" ])

    fill_in 'Nome', with: 'Pizzas'
    fill_in 'Descrição', with: 'Categorias de pizzas diversas do nosso restaurante'

    click_on 'Salvar'

    expect(page).to have_content('Erro interno no servidor')
    expect(page).not_to have_css('.modal-content', visible: true)
    expect(page).to have_current_path(menu_path)
    find('span', text: 'Categorias').click
    expect(page).to have_content('Pizza')
    expect(Category.last.name).to eq('Pizza')
    expect(Category.last.description).to eq('Categorias de pizzas diversas')
    expect(Category.last.restaurant).to eq(user.restaurant)
  end
end
