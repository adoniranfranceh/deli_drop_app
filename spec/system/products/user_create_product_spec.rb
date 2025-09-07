require 'rails_helper'

describe 'User creates a product', type: :system do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:category) { create(:category, name: 'Combos', restaurant: restaurant) }

  before do
    restaurant
    category
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click
    click_button 'Novo Produto'
  end

  it 'successfully with multiple groups and modifiers' do
    # Arrange
    fill_in 'Nome', with: 'Combo Mix'
    fill_in 'Categoria', with: 'Comb'
    within '.dropdown-menu' do
      find('.dropdown-item', text: 'Combos').click
    end
    fill_in 'Preço', with: '4990'
    fill_in 'Tempo de preparo', with: '14'
    fill_in 'Descrição', with: 'Este é um combo mix'
    fill_in 'Imagem', with: 'http://productimage.com'
    fill_in 'Ingredientes', with: 'Bebidas'
    click_button 'Incluir'
    find('label', text: 'Produto em destaque').click
    click_button 'Sim, adicionar opções'
    click_button 'Continuar'

    # === first group(1 modifier) ===
    click_button 'Escolha Única'
    click_button 'Adicionar Opção'
    find('[placeholder="Nome do Grupo"]').set('Escolha uma bebida')
    fill_in 'Min de Opções', with: '1'
    find('[placeholder="Nome da Opção"]').set('Água')
    fill_in 'Preço', with: '100'
    find('[placeholder="URL da Imagem"]').set('http://image.com')

    # === second group (2 modifiers) ===
    click_button 'Adicionar Grupo'
    within all('.modifier-group-card').last do
      fill_in 'Tipo de Escolha', with: 'Escolha'
      within '.dropdown-menu' do
        find('.dropdown-item', text: 'Escolha Única').click
      end
      click_button 'Adicionar Opção'
      find('[placeholder="Nome do Grupo"]').set('Escolha uma sobremesa')
      fill_in 'Min de Opções', with: '1'

      # first modifier
      find('[placeholder="Nome da Opção"]').set('Pudim')
      fill_in 'Preço', with: '200'
      find('[placeholder="URL da Imagem"]').set('http://image.com/pudim')

      # first modifier
      click_button 'Adicionar Opção'
      all('[placeholder="Nome da Opção"]').last.set('Bolo')
      all('[id="product-price"]').last.set('300')
      all('[placeholder="URL da Imagem"]').last.set('http://image.com/bolo')
    end

    # Act
    click_button 'Continuar'
    click_button 'Salvar'

    # Assert
    expect(page).to have_content 'Produto criado com sucesso!'
    expect(page).to have_current_path(menu_path)

    product = Product.last
    expect(product.name).to eq('Combo Mix')
    expect(product.category).to eq(category)
    expect(product.base_price).to eq(4990)
    expect(product.duration).to eq(14)
    expect(product.description).to eq('Este é um combo mix')
    expect(product.image).to eq('http://productimage.com')
    expect(product.ingredients).to eq([ 'Bebidas' ])
    expect(product.status).to eq('active')
    expect(product.featured).to eq(true)
    expect(product.restaurant).to eq(user.restaurant)

    # first group
    group1 = product.modifier_groups.find_by(name: 'Escolha uma bebida')
    expect(group1.input_type).to eq('single_choice')
    expect(group1.min).to eq(1)
    expect(group1.max).to eq(1)
    expect(group1.free_limit).to eq(1)

    modifier1 = group1.modifiers.last
    expect(modifier1.name).to eq('Água')
    expect(modifier1.base_price).to eq(100)
    expect(modifier1.image).to eq('http://image.com')

    # second group
    group2 = product.modifier_groups.find_by(name: 'Escolha uma sobremesa')
    expect(group2.input_type).to eq('single_choice')
    expect(group2.min).to eq(1)
    expect(group2.max).to eq(1)
    expect(group2.free_limit).to eq(1)

    modifiers2 = group2.modifiers
    expect(modifiers2.map(&:name)).to contain_exactly('Pudim', 'Bolo')
    expect(modifiers2.map(&:base_price)).to contain_exactly(200, 300)
    expect(modifiers2.map(&:image)).to contain_exactly('http://image.com/pudim', 'http://image.com/bolo')
  end

end
