require 'rails_helper'

describe 'User view product form', type: :system do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }

  before do
    restaurant
    login_as user
    visit root_path
    find('span', text: 'Gerenciar Menu').click
    click_button 'Novo Produto'
  end

  context 'in first step' do
    it "and see fields" do
      within '.step-indicator' do
        within find('[class="step-label active"]') do
          expect(page).to have_content 'Informações Básicas'
          expect(page).not_to have_content 'Modificadores'
          expect(page).not_to have_content 'Revisão'
        end
        expect(page).to have_content 'Modificadores'
        expect(page).to have_content 'Revisão'
      end

      within '.quick-container' do
        expect(page).to have_content 'Ações rápidas'
        expect(page).to have_content 'Escolha um template para preencher automaticamente'
        expect(page).to have_content 'Pizza'
        expect(page).to have_content 'Hambúrguer'
        expect(page).to have_content 'Açaí'
        expect(page).to have_content 'Bebida'
      end

      within '.form-grid' do
        expect(page).to have_field('Nome', with: '', placeholder: 'Nome do Produto')
        expect(page).to have_field('Categoria', with: '', placeholder: 'Todas as categorias')
        expect(page).to have_field('Preço', with: '0,00')
        expect(page).to have_field('Tempo de preparo', with: '', placeholder: 'Tempo de preparo (minutos)')
        expect(page).to have_field('Descrição', with: '', placeholder: 'Descreva o produto...')
        expect(page).to have_field('Imagem', with: '', placeholder: 'Imagem')
        expect(page).to have_field('Ingredientes', with: '', placeholder: 'Digite um ingrediente')
        expect(page).to have_button('Incluir', disabled: true)
        toggle_active_product = find_field('Produto ativo', type: 'checkbox', visible: false)
        expect(toggle_active_product).to be_checked
        toggle_featured_product = find_field('Produto em destaque', type: 'checkbox', visible: false)
        expect(toggle_featured_product).not_to be_checked
      end

      expect(page).to have_button('Continuar', disabled: true)
      expect(page).not_to have_css('.cancel', text: 'Voltar')
    end

    context "and use quick template" do
      it 'for filling like Pizza' do
        within '.quick-container' do
          find('span', text: 'Pizza').click
        end

        within '.form-grid' do
          expect(page).to have_field('Nome', with: 'Pizza Margherita', placeholder: 'Nome do Produto')
          expect(page).to have_field('Categoria', with: '', placeholder: 'Todas as categorias')
          expect(page).to have_content('Categoria é obrigatória')
          expect(page).to have_field('Preço', with: '35,90')
          expect(page).to have_field('Tempo de preparo', with: '25', placeholder: 'Tempo de preparo (minutos)')
          expect(page).to have_field('Descrição', with: 'Deliciosa pizza de queijo e tomate.', placeholder: 'Descreva o produto...')
          expect(page).to have_field(
            'Imagem',
            with: 'https://static.itdg.com.br/images/1200-630/47d6583c93d77edac5244cab67ba660b/253447-378226756-original.jpg',
            placeholder: 'Imagem'
          )
          expect(page).to have_field('Ingredientes', with: '', placeholder: 'Digite um ingrediente')
          expect(page).to have_button('Incluir', disabled: true)
          within '.chips-container' do
            expect(page).to have_content("Queijo\n×\nTomate\n×\nManjericão\n×")
          end
          toggle_active_product = find_field('Produto ativo', type: 'checkbox', visible: false)
          expect(toggle_active_product).to be_checked
          toggle_featured_product = find_field('Produto em destaque', type: 'checkbox', visible: false)
          expect(toggle_featured_product).not_to be_checked
        end

        expect(page).to have_button('Continuar', disabled: true)
        expect(page).not_to have_css('.cancel', text: 'Voltar')
      end

      it 'for filling like Hambúrguer' do
        within '.quick-container' do
          find('span', text: 'Hambúrguer').click
        end

        within '.form-grid' do
          expect(page).to have_field('Nome', with: 'Hambúrguer Clássico', placeholder: 'Nome do Produto')
          expect(page).to have_field('Categoria', with: '', placeholder: 'Todas as categorias')
          expect(page).to have_content('Categoria é obrigatória')
          expect(page).to have_field('Preço', with: '28,50')
          expect(page).to have_field('Tempo de preparo', with: '20', placeholder: 'Tempo de preparo (minutos)')
          expect(page).to have_field('Descrição', with: 'Pão, carne, queijo e molho especial.', placeholder: 'Descreva o produto...')
          expect(page).to have_field(
            'Imagem',
            with: 'https://www.minhareceita.com.br/app/uploads/2023/08/x-bacon-portal-minha-receita.jpg',
            placeholder: 'Imagem'
          )
          expect(page).to have_field('Ingredientes', with: '', placeholder: 'Digite um ingrediente')
          expect(page).to have_button('Incluir', disabled: true)
          within '.chips-container' do
            expect(page).to have_content("Pão\n×\nCarne\n×\nQueijo\n×")
          end
          toggle_active_product = find_field('Produto ativo', type: 'checkbox', visible: false)
          expect(toggle_active_product).to be_checked
          toggle_featured_product = find_field('Produto em destaque', type: 'checkbox', visible: false)
          expect(toggle_featured_product).not_to be_checked
        end

        expect(page).to have_button('Continuar', disabled: true)
        expect(page).not_to have_css('.cancel', text: 'Voltar')
      end

      it 'for filling like Açaí' do
         within '.quick-container' do
          find('span', text: 'Açaí').click
        end

        within '.form-grid' do
          expect(page).to have_field('Nome', with: 'Tigela de Açaí', placeholder: 'Nome do Produto')
          expect(page).to have_field('Categoria', with: '', placeholder: 'Todas as categorias')
          expect(page).to have_content('Categoria é obrigatória')
          expect(page).to have_field('Preço', with: '18,00')
          expect(page).to have_field('Tempo de preparo', with: '15', placeholder: 'Tempo de preparo (minutos)')
          expect(page).to have_field('Descrição', with: 'Açaí com banana, granola e mel.', placeholder: 'Descreva o produto...')
          expect(page).to have_field(
            'Imagem',
            with: 'https://flordejambu.com/wp-content/uploads/2022/05/acai.png',
            placeholder: 'Imagem'
          )
          expect(page).to have_field('Ingredientes', with: '', placeholder: 'Digite um ingrediente')
          expect(page).to have_button('Incluir', disabled: true)
          expect(page).not_to have_css '.chips-container'

          toggle_active_product = find_field('Produto ativo', type: 'checkbox', visible: false)
          expect(toggle_active_product).to be_checked
          toggle_featured_product = find_field('Produto em destaque', type: 'checkbox', visible: false)
          expect(toggle_featured_product).not_to be_checked
        end

        expect(page).to have_button('Continuar', disabled: true)
        expect(page).not_to have_css('.cancel', text: 'Voltar')
      end

      it 'for filling like Bebida' do
        within '.quick-container' do
          find('span', text: 'Bebida').click
        end

        within '.form-grid' do
          expect(page).to have_field('Nome', with: 'Suco Natural', placeholder: 'Nome do Produto')
          expect(page).to have_field('Categoria', with: '', placeholder: 'Todas as categorias')
          expect(page).to have_content('Categoria é obrigatória')
          expect(page).to have_field('Preço', with: '7,50')
          expect(page).to have_field('Tempo de preparo', with: '5', placeholder: 'Tempo de preparo (minutos)')
          expect(page).to have_field('Descrição', with: 'Suco natural de frutas frescas.', placeholder: 'Descreva o produto...')
          expect(page).to have_field(
            'Imagem',
            with: 'https://s3-sa-east-1.amazonaws.com/deliveryon-uploads/products/imperio/38_5c58b562c06f5.jpg',
            placeholder: 'Imagem'
          )
          expect(page).to have_field('Ingredientes', with: '', placeholder: 'Digite um ingrediente')
          expect(page).to have_button('Incluir', disabled: true)
          within '.chips-container' do
            expect(page).to have_content("Fruta\n×")
          end
          toggle_active_product = find_field('Produto ativo', type: 'checkbox', visible: false)
          expect(toggle_active_product).to be_checked
          toggle_featured_product = find_field('Produto em destaque', type: 'checkbox', visible: false)
          expect(toggle_featured_product).not_to be_checked
        end

        expect(page).to have_button('Continuar', disabled: true)
        expect(page).not_to have_css('.cancel', text: 'Voltar')
      end
    end

    it 'and see errors in all required fields after touched' do
      fill_in 'Nome', with: ''
      fill_in 'Categoria', with: ''
      within '.dropdown-menu' do
        find('.dropdown-item', text: 'Todas as categorias').click
      end
      fill_in 'Preço', with: ''
      fill_in 'Tempo de preparo', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Imagem', with: ''
      fill_in 'Descrição', with: ''

      expect(page).to have_content 'Nome do produto é obrigatório'
      expect(page).to have_content 'Categoria é obrigatória'
      expect(page).to have_content 'Preço é obrigatório'
      expect(page).to have_content 'Tempo de preparo é obrigatório'
      expect(page).to have_content 'Descrição é obrigatória'
      expect(page).not_to have_content 'Imagem do produto é obrigatório'
    end

    it 'and see quick template after valid fields' do
      fill_first_step

      expect(page).to have_content 'Seu produto tem opções?'
      expect(page).to have_content 'Modificadores permitem que seus clientes personalizem o produto. Por exemplo:'
      expect(page).to have_content "Pizza\nTamanhos, sabores, bordas"
      expect(page).to have_content "Açaí\nComplementos, frutas, coberturas"
      expect(page).to have_content "Hambúrguer\nAdicionais, molhos, ponto da carne"
      expect(page).to have_content "Bebidas\nTamanhos, temperaturas"
      expect(page).to have_button 'Sim, adicionar opções'
      expect(page).to have_button 'Não, produto simples'
    end
  end

  context 'in second step' do
    it "and see fields" do
      fill_first_step
      click_button 'Sim, adicionar opções'
      click_button 'Continuar'
      click_button 'Escolha Única'
      click_button 'Adicionar Opção'

      input_group_name = find('input[placeholder="Nome do Grupo"]')
      expect(input_group_name.value).to eq('')
      expect(page).to have_field('Tipo de Escolha', placeholder: 'Escolha Única')
      expect(page).to have_field('Min de Opções', with: '', placeholder: 'Mínimo')
      expect(page).to have_field('Max de Opções', with: '1', placeholder: 'Máximo', disabled: true)
      expect(page).to have_field('Limite Grátis', with: '1', placeholder: 'Quantidade', disabled: true)
      expect(page).to have_content('1 opção')
      input_option_name = find('input[placeholder="Nome do Grupo"]')
      expect(input_option_name.value).to eq('')
      expect(page).to have_field('Preço', with: '0,00')
      input_image = find('input[placeholder="URL da Imagem"]')
      expect(input_image.value).to eq('')
      expect(page).to have_css('.cancel', text: 'Voltar')
    end

    context 'and see errors in all required fields' do
      it 'that is blanked' do
        fill_first_step
        click_button 'Incluir'
        click_button 'Sim, adicionar opções'
        click_button 'Continuar'
        click_button 'Quantidade'
        click_button 'Adicionar Opção'

        find('[placeholder="Nome do Grupo"]').set('Escolha uma bebida')
        fill_in 'Tipo de Escolha', with: ''
        within '.dropdown-menu' do
          find('.dropdown-item', text: 'Selecionar Tipo de escolha').click
        end
        fill_in 'Min de Opções', with: ''
        fill_in 'Max de Opções', with: ''
        fill_in 'Limite Grátis', with: ''
        find('[placeholder="Nome da Opção"]').set('')
        fill_in 'Preço', with: '0,00'
        find('[placeholder="URL da Imagem"]').set('')

        within '.modifier-group-card' do
          expect(page).to have_content 'Nome é obrigatório'
          expect(page).to have_content 'Tipo é obrigatório'
          expect(page).to have_content 'Min é obrigatório'
          expect(page).to have_content 'Máx é obrigatório'
          expect(page).to have_content 'Limite grátis é obrigatório'
        end
        within '.modifier-row' do
          expect(page).to have_content 'Nome é obrigatório'
          expect(page).not_to have_content 'Preço é obrigatório'
          expect(page).not_to have_content 'Imagem é obrigatório'
        end
      end

      it 'for max to be less that min and quantity' do
        fill_first_step
        click_button 'Incluir'
        click_button 'Sim, adicionar opções'
        click_button 'Continuar'
        click_button 'Quantidade'

        fill_in 'Min de Opções', with: '4'
        fill_in 'Max de Opções', with: '3'
        fill_in 'Limite Grátis', with: '4'
        find('[placeholder="Nome do Grupo"]').set('Escolha uma bebida')

        within '.modifier-group-card' do
          expect(page).to have_content '0 opções'
          expect(page).to have_content 'Máx deve ser maior que o Mín'
          expect(page).to have_content 'Limite grátis não pode ser maior que max'
          expect(page).to have_field 'Min de Opções', disabled: false
          expect(page).to have_field 'Max de Opções', disabled: false
          expect(page).to have_field 'Limite Grátis', disabled: false
        end
        expect(page).to have_css('.cancel', text: 'Voltar')
        expect(page).to have_button 'Continuar', disabled: true
      end

      it 'for max to be 0' do
        fill_first_step
        click_button 'Incluir'
        click_button 'Sim, adicionar opções'
        click_button 'Continuar'
        click_button 'Múltipla Escolha'

        fill_in 'Max de Opções', with: '0'
        fill_in 'Min de Opções', with: '1'
        find('[placeholder="Nome do Grupo"]').set('Escolha uma bebida')

        within '.modifier-group-card' do
          expect(page).to have_field 'Min de Opções', disabled: false
          expect(page).to have_field 'Max de Opções', disabled: false
          expect(page).to have_content 'Máx não pode ser 0'
          expect(page).to have_field 'Limite Grátis', disabled: true
        end
        expect(page).to have_css('.cancel', text: 'Voltar')
        expect(page).to have_button 'Continuar', disabled: true
      end

      it 'for multiple_choice to be 1' do
        fill_first_step
        click_button 'Incluir'
        click_button 'Sim, adicionar opções'
        click_button 'Continuar'
        click_button 'Múltipla Escolha'

        fill_in 'Max de Opções', with: '1'
        fill_in 'Min de Opções', with: '1'
        find('[placeholder="Nome do Grupo"]').set('Escolha uma bebida')

        within '.modifier-group-card' do
          expect(page).to have_field 'Min de Opções', disabled: false
          expect(page).to have_field 'Max de Opções', disabled: false
          expect(page).to have_content "Múltipla Escolha:\nMáx deve ser maior"
          expect(page).to have_field 'Limite Grátis', disabled: true
        end
        expect(page).to have_css('.cancel', text: 'Voltar')
        expect(page).to have_button 'Continuar', disabled: true
      end
    end
  end

  context 'in third step' do
    it "and see third steps'fields" do
      go_to_third_step

      expect(page).to have_content 'Combo Mix'
      expect(page).to have_content 'Este é um combo mix'
      expect(page).to have_content 'R$ 49,90'
      expect(page).to have_content '14 min'
      within '.header-modifier' do
        expect(page).to have_content 'Escolha uma bebida'
        expect(page).to have_content 'Escolha 1 grátis'
        expect(page).to have_content '0/1'
      end

      within '.modifiers' do
        expect(page).to have_content 'Água'
        expect(page).to have_content 'Incluso'
        expect(page).to have_css '.custom-checkbox'
      end
      expect(page).to have_content 'Ingredientes:'
      expect(page).to have_content 'Bebidas'
      expect(page).to have_css('.cancel', text: 'Voltar')
      expect(page).to have_content 'Salvar'
    end
  end

  def fill_first_step(name: 'Combo Mix', category: 'Combos', price: '4990',
                      duration: '14', description: 'Este é um combo mix',
                      ingredients: 'Bebidas')
    fill_in 'Nome', with: name
    fill_in 'Categoria', with: category[0..2]
    within '.dropdown-menu' do
      find('.dropdown-item', text: category).click
    end
    fill_in 'Preço', with: price
    fill_in 'Tempo de preparo', with: duration
    fill_in 'Descrição', with: description
    fill_in 'Ingredientes', with: ingredients if ingredients
  end

  def go_to_second_step
    click_button 'Sim, adicionar opções'
    click_button 'Continuar'
  end

  def go_to_third_step
    fill_first_step
    click_button 'Incluir'
    go_to_second_step
    click_button 'Escolha Única'
    click_button 'Adicionar Opção'
    find('[placeholder="Nome do Grupo"]').set('Escolha uma bebida')
    fill_in 'Min de Opções', with: '1'
    find('[placeholder="Nome da Opção"]').set('Água')
    fill_in 'Preço', with: '1'
    click_button 'Continuar'
  end
end
