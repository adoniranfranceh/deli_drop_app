require 'rails_helper'

describe 'User creates a restaurant' do
  context 'when logged in' do
    it 'shows the restaurant registration form' do
      restaurant_user = create(:restaurant_user)
      login_as(restaurant_user, scope: :restaurant_user)

      visit root_path

      expect(page).to have_content('Informações Básicas')
      expect(page).to have_content('Preencha as informações básicas do seu restaurante')
      expect(page).to have_current_path(new_restaurant_path)
      expect(page).to have_content('Cadastre seu restaurante para continuar')
      expect(page).not_to have_button('Voltar a tela inicial')
      expect(page).to have_field('Nome')
      expect(page).to have_field('Tipo de Culinária')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Imagem')
      expect(page).to have_field('Telefone')
      expect(page).to have_field('Endereço Completo')
      expect(page).not_to have_button('Cancelar')
      expect(page).to have_button('Salvar', disabled: true)
    end

    it 'and sees an error message if something goes wrong on the server' do
      restaurant_user = create(:restaurant_user)
      login_as(restaurant_user, scope: :restaurant_user)

      allow_any_instance_of(Restaurant).to receive(:save).and_return(false)
      allow_any_instance_of(Restaurant).to receive_message_chain(:errors, :full_messages)
                                       .and_return([ "Erro interno no servidor" ])

      visit root_path

      fill_in 'Nome', with: 'Restaurante Bugado'
      fill_in 'Tipo de Culinária', with: 'Italiana'
      within '.dropdown-menu' do
        find('.dropdown-item', text: 'Italiana').click
      end
      fill_in 'Descrição', with: 'Esse restaurante vai falhar'
      fill_in 'Imagem', with: 'http://www.imagem.com/imagem.png'
      fill_in 'Telefone', with: '(11) 99999-9999'
      fill_in 'Endereço Completo', with: 'Av. Paulista, 2000'

      click_on 'Salvar'

      expect(page).to have_content('Erro interno no servidor')
      expect(page).to have_current_path(new_restaurant_path)
    end

    it 'successfully' do
      restaurant_user = create(:restaurant_user)
      login_as(restaurant_user, scope: :restaurant_user)

      visit root_path

      fill_in 'Nome', with: 'Restaurante Legal'
      fill_in 'Tipo de Culinária', with: 'Brasi'
      within '.dropdown-menu' do
        find('.dropdown-item', text: 'Brasileira').click
      end
      fill_in 'Descrição', with: 'Comida boa'
      fill_in 'Imagem', with: 'http://www.imagem.com/imagem.png'
      fill_in 'Telefone', with: '(11) 99999-9999'
      fill_in 'Endereço Completo', with: 'Av. Brasil, 1000'
      click_on 'Salvar'

      expect(page).to have_content('Restaurante criado com sucesso')
      expect(page).to have_current_path(root_path)
      expect(Restaurant.count).to eq 1
      restaurant = Restaurant.last
      expect(restaurant_user.reload.restaurant).to eq restaurant
      expect(restaurant.name).to eq 'Restaurante Legal'
      expect(restaurant.culinary_style).to eq 'brazilian'
      expect(restaurant.description).to eq 'Comida boa'
      expect(restaurant.image).to eq 'http://www.imagem.com/imagem.png'
      expect(restaurant.phone).to eq '(11) 99999-9999'
      expect(restaurant.address).to eq 'Av. Brasil, 1000'
    end

    it 'and see errors in all required fields after touched' do
      restaurant_user = create(:restaurant_user)
      login_as(restaurant_user, scope: :restaurant_user)

      visit root_path
      fill_in 'Nome', with: ''
      fill_in 'Tipo de Culinária', with: ''
      within '.dropdown-menu' do
        find('.dropdown-item', text: 'Tipo de Culinária').click
      end
      fill_in 'Descrição', with: ''
      fill_in 'Imagem', with: ''
      fill_in 'Telefone', with: ''
      fill_in 'Endereço', with: ''
      fill_in 'Telefone', with: ''

      expect(page).not_to have_button('Cancelar')
      expect(page).to have_button('Salvar', disabled: true)
      expect(page).to have_content('Cadastre seu restaurante para continuar')
      expect(page).to have_content('Nome do restaurante é obrigatório')
      expect(page).to have_content('Estilo culinário é obrigatório')
      expect(page).to have_content('Descrição é obrigatória')
      expect(page).to have_content('URL da imagem é obrigatória')
      expect(page).to have_content('Telefone é obrigatório')
      expect(page).not_to have_content('Endereço é obrigatório')
    end
  end
end
