require 'rails_helper'

describe 'User edits a product', type: :system do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:product) { create(:product, restaurant:, category: Category.find_by(name: 'Combos'),
                                   name: 'Combo Mix', base_price: 4990, duration: 10) }
  let(:modifier_group) { create(:modifier_group, product:, name: 'Escolha uma bebida',
                                                 input_type: 'single_choice', min: 1, max: 1, free_limit: 1) }
  let(:modifier) { create(:modifier, modifier_group:, name: 'Coca-Cola', base_price: 500, image: 'http://image.com') }
  let(:modifier2) { create(:modifier, modifier_group:, name: 'Fanta Laranja', base_price: 500, image: 'http://image.com') }

  before do
    restaurant
    product
    modifier_group
    modifier
    modifier2
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click
    within find('.product-card', text: 'Combo Mix') do
      click_button 'Editar'
    end
  end

  it 'successfully with multiple groups and modifiers' do
    fill_in 'Preço', with: '4090', fill_options: { clear: :backspace }
    fill_in 'Tempo de preparo', with: '10'
    find('label', text: 'Produto em destaque').click

    click_button 'Continuar'

    within '.modifier-group-card' do
      find('[placeholder="Nome do Grupo"]').set('Escolha 2 bebida')
      fill_in 'Tipo de Escolha', with: 'Múltipla Escolha'
      within '.dropdown-menu' do
        find('.dropdown-item', text: 'Múltipla Escolha').click
      end
      fill_in 'Min de Opções', with: '2'
      fill_in 'Max de Opções', with: '2'

      all('[placeholder="Nome da Opção"]').first.set('Água')
      all('[id="product-price"]').first.set('5,00')
      all('[placeholder="URL da Imagem"]').first.set('http://image.com')

      all('[placeholder="Nome da Opção"]').last.set('Suco')
      all('[id="product-price"]').last.set('8,00')
      all('[placeholder="URL da Imagem"]').last.set('http://image.com/suco')

      click_button 'Adicionar Opção'
      all('[placeholder="Nome da Opção"]').last.set('Coca-Cola')
      all('[id="product-price"]').last.set('12,00')
      all('[placeholder="URL da Imagem"]').last.set('http://image.com/cocacola')
    end

    click_button 'Continuar'
    click_button 'Salvar'

    expect(page).to have_content 'Produto atualizado com sucesso!', wait: 5
    expect(page).to have_current_path(menu_path)

    product = Product.last
    expect(product.name).to eq('Combo Mix')
    expect(product.category.name).to eq('Combos')
    expect(product.base_price).to eq(4090)
    expect(product.duration).to eq(10)
    expect(product.status).to eq('active')
    expect(product.featured).to eq(true)

    group = product.modifier_groups.find_by(name: 'Escolha 2 bebida')
    expect(group.input_type).to eq('multiple_choice')
    expect(group.min).to eq(2)
    expect(group.max).to eq(2)
    expect(group.free_limit).to eq(2)

    modifiers = group.modifiers
    expect(modifiers.map(&:name)).to eq([ 'Água', 'Suco', 'Coca-Cola' ])
    expect(modifiers.map(&:base_price)).to eq([ 500, 800, 1200 ])
    expect(modifiers.map(&:image)).to eq([ 'http://image.com', 'http://image.com/suco', 'http://image.com/cocacola' ])
  end

  it 'successfully removing multiple groups and modifiers' do
    fill_in 'Preço', with: '4090', fill_options: { clear: :backspace }
    fill_in 'Tempo de preparo', with: '10'
    find('label', text: 'Produto em destaque').click

    click_button 'Continuar'

    within '.modifier-group-card' do
      find('.bin-btn').click
    end

    click_button 'Continuar'
    click_button 'Salvar'

    expect(page).to have_content 'Produto atualizado com sucesso!', wait: 5
    expect(page).to have_current_path(menu_path)

    product = Product.last
    expect(product.name).to eq('Combo Mix')
    expect(product.category.name).to eq('Combos')
    expect(product.base_price).to eq(4090)
    expect(product.duration).to eq(10)
    expect(product.status).to eq('active')
    expect(product.featured).to eq(true)
    expect(product.modifier_groups.count).to eq(0)
    expect(ModifierGroup.count).to eq(0)
    expect(Modifier.count).to eq(0)
  end

  it 'successfully removing modifier' do
    fill_in 'Preço', with: '4090', fill_options: { clear: :backspace }
    fill_in 'Tempo de preparo', with: '10'
    find('label', text: 'Produto em destaque').click

    click_button 'Continuar'

    all('.close-btn').last.click

    click_button 'Continuar'
    click_button 'Salvar'

    expect(page).to have_content 'Produto atualizado com sucesso!', wait: 5
    expect(page).to have_current_path(menu_path)

    product = Product.last
    expect(product.name).to eq('Combo Mix')
    expect(product.category.name).to eq('Combos')
    expect(product.base_price).to eq(4090)
    expect(product.duration).to eq(10)
    expect(product.status).to eq('active')
    expect(product.featured).to eq(true)
    expect(product.modifier_groups.count).to eq(1)
    expect(product.modifier_groups.first.modifiers.count).to eq(1)
    expect(product.modifier_groups.first.modifiers.first.name).to eq('Coca-Cola')
    expect(ModifierGroup.count).to eq(1)
    expect(Modifier.count).to eq(1)
  end

  it 'and sees an error message if something goes wrong on the server' do
    allow_any_instance_of(Product).to receive(:save).and_return(false)
    allow_any_instance_of(Product).to receive_message_chain(:errors, :full_messages)
                                  .and_return([ "Erro interno no servidor" ])
    fill_in 'Preço', with: '4090'
    click_button 'Continuar'
    click_button 'Continuar'

    click_button 'Salvar'

    expect(page).to have_content 'Erro interno no servidor'
    expect(page).to have_current_path(edit_product_path(product.id))

    expect(Product.last.base_price).to eq 4990
    expect(Product.count).to eq 1
    expect(ModifierGroup.count).to eq 1
    expect(Modifier.count).to eq 2
  end
end
