require 'rails_helper'

describe 'User views product form product edit', type: :system do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:product) { create(:product, restaurant:, category: Category.find_by(name: 'Combos'),
                                   name: 'Combo Mix', base_price: 4990, duration: 10,
                                   ingredients: [ 'bebidas' ]) }
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

  it 'and see filled fields' do
    expect(page).to have_field('Nome', with: 'Combo Mix')
    expect(page).to have_field('Categoria', with: '', placeholder: 'Combos')
    expect(page).to have_field('Preço', with: '49,90')
    expect(page).to have_field('Tempo de preparo', with: '10')
    toggle_active_product = find_field('Produto ativo', type: 'checkbox', visible: false)
    expect(toggle_active_product).to be_checked
    toggle_featured_product = find_field('Produto em destaque', type: 'checkbox', visible: false)
    expect(toggle_featured_product).not_to be_checked
    within '.chips-container' do
      expect(page).to have_content "bebidas\n×"
    end
    expect(page).to have_css('[class="step-label active"]', text: 'Informações Básicas')
    expect(page).to have_css('[class="step-label"]', text: 'Modificadores')
    expect(page).to have_css('[class="step-label"]', text: 'Revisão')


    click_button 'Continuar'

    expect(page).to have_field('Nome do Grupo', with: 'Escolha uma bebida')
    expect(page).to have_field('Tipo de Escolha', with: '', placeholder: 'Escolha Única')
    expect(page).to have_field('Min de Opções', with: '1')
    expect(page).to have_field('Max de Opções', with: '1', disabled: true)
    expect(page).to have_field('Limite Grátis', with: '1', disabled: true)
    expect(page).to have_field('Nome da Opção', with: 'Coca-Cola')
    expect(page).to have_field('Preço', with: '5,00')
    expect(page).to have_field('URL da Imagem', with: 'http://image.com')
    expect(page).to have_field('Nome da Opção', with: 'Fanta Laranja')
    expect(page).to have_field('Preço', with: '5,00')
    expect(page).to have_field('URL da Imagem', with: 'http://image.com')
    expect(page).to have_css('[class="step-label completed"]', text: 'Informações Básicas')
    expect(page).to have_css('[class="step-label active"]', text: 'Modificadores')
    expect(page).to have_css('[class="step-label"]', text: 'Revisão')

    click_button 'Continuar'

    expect(page).to have_css('[class="step-label completed"]', text: 'Informações Básicas')
    expect(page).to have_css('[class="step-label completed"]', text: 'Modificadores')
    expect(page).to have_css('[class="step-label active"]', text: 'Revisão')
    expect(page).to have_content 'Combo Mix'
    expect(page).to have_content 'R$ 49,90'
    expect(page).to have_content '10 min'
    expect(page).to have_content 'Escolha uma bebida'
    expect(page).to have_content 'Escolha 1 grátis'
    expect(page).to have_content "Coca-Cola\nIncluso\nR$ 5,00"
    expect(page).to have_content "Fanta Laranja\nIncluso\nR$ 5,00"
    expect(page).to have_content "Ingredientes:\nbebidas"
    expect(page).to have_field('Algum comentário?', with: '')
    expect(page).to have_button('Salvar')
  end

  it 'and remove modifier groups' do
    click_button 'Continuar'

    within '.modifier-group-card' do
      find('.bin-btn').click
    end

    click_button 'Continuar'

    expect(page).not_to have_content 'Escolha uma bebida'
    expect(page).not_to have_content 'Escolha 1 grátis'
    expect(page).not_to have_content "Coca-Cola\nIncluso\nR$ 5,00"
    expect(page).not_to have_content "Fanta Laranja\nIncluso\nR$ 5,00"
    expect(page).to have_content 'Combo Mix'
    expect(page).to have_content 'R$ 49,90'
    expect(page).to have_content '10 min'
  end

  it 'successfully removing modifier' do
    click_button 'Continuar'

    all('.close-btn').last.click

    click_button 'Continuar'
    expect(page).to have_content 'Escolha uma bebida'
    expect(page).to have_content 'Escolha 1 grátis'
    expect(page).to have_content "Coca-Cola\nIncluso\nR$ 5,00"
    expect(page).not_to have_content "Fanta Laranja\nIncluso\nR$ 5,00"
    expect(page).to have_content 'Combo Mix'
    expect(page).to have_content 'R$ 49,90'
    expect(page).to have_content '10 min'
  end
end
