require 'rails_helper'

RSpec.describe 'User updates a restaurant', type: :system do
  let(:restaurant_user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, name: 'Antigo nome', culinary_style: 'acai',
                                         description: 'Este é um restaurante', restaurant_user: restaurant_user,
                                         image: 'http/image.com', phone: '89 99999-9999', address: 'Rua das Palmeiras, 400') }

  before do
    login_as restaurant_user
    restaurant
  end

  it 'successfully updates the restaurant' do
    visit root_path

    click_on 'Editar'

    fill_in 'Nome', with: 'Novo nome', fill_options: { clear: :backspace }
    fill_in 'Endereço Completo', with: 'Rua das Oliverias, 100', fill_options: { clear: :backspace }
    click_button 'Salvar'

    expect(page).to have_content('Restaurante atualizado com sucesso!')
    expect(page).to have_content('Bem-vindo de volta, Novo nome')
    expect(restaurant.reload.name).to eq('Novo nome')
    expect(restaurant.reload.culinary_style).to eq('acai')
    expect(restaurant.reload.description).to eq('Este é um restaurante')
    expect(restaurant.reload.restaurant_user).to eq(restaurant_user)
    expect(restaurant.reload.image).to eq('http/image.com')
    expect(restaurant.reload.phone).to eq('89 99999-9999')
    expect(restaurant.reload.address).to eq('Rua das Oliverias, 100')
  end

  it 'shows validation errors when touch required fields' do
    visit edit_restaurant_path(restaurant)

    fill_in 'Nome', with: '', fill_options: { clear: :backspace }
    fill_in 'Descrição', with: '', fill_options: { clear: :backspace }
    fill_in 'Nome', with: ''

    expect(page).to have_content("Nome do restaurante é obrigatório")
    expect(page).to have_content("Descrição é obrigatória")
    expect(page).to have_button('Salvar', disabled: true)
  end

  it 'and sees an error message if something goes wrong on the server' do
    login_as(restaurant_user, scope: :restaurant_user)

    allow_any_instance_of(Restaurant).to receive(:save).and_return(false)
    allow_any_instance_of(Restaurant).to receive_message_chain(:errors, :full_messages)
                                      .and_return([ "Erro interno no servidor" ])

    visit root_path
    click_on 'Editar'

    fill_in 'Nome', with: 'Restaurante Bugado'
    fill_in 'Tipo de Culinária', with: 'Italiana'
    within '.dropdown-menu' do
      find('.dropdown-item', text: 'Italiana').click
    end

    click_on 'Salvar'

    expect(page).to have_content('Erro interno no servidor')
    expect(page).to have_current_path(edit_restaurant_path(restaurant))
  end
end
