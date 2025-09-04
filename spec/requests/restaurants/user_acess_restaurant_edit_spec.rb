require 'rails_helper'

describe 'User access edit form path' do
  context 'GET restaurant/:id/edit' do
    it 'successfully' do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      login_as(user, scope: :restaurant_user)

      get edit_restaurant_path(restaurant)

      expect(response).to have_http_status(200)
      expect(flash[:alert]).to be_nil
      expect(flash[:notice]).to be_nil
    end

    context 'cannot access' do
      it 'when not logged in' do
        user = create(:restaurant_user)
        restaurant = create(:restaurant, restaurant_user: user)

        get edit_restaurant_path(restaurant)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_restaurant_user_session_path)
        expect(flash[:alert]).to eq 'Para continuar, efetue login ou registre-se.'
        expect(flash[:notice]).to be_nil
      end

      context 'when trying to access another restaurant' do
        it 'and current user has restaurant' do
          user = create(:restaurant_user)
          other_user = create(:restaurant_user, email: 'other@email.com')
          create(:restaurant, restaurant_user: user)
          other_restaurant = create(:restaurant, restaurant_user: other_user)
          login_as(user, scope: :restaurant_user)

          get edit_restaurant_path(other_restaurant)

          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq 'Você não tem permissão para executar esta ação'
          expect(flash[:notice]).to be_nil
        end

        it 'and current user no has restaurant' do
          user = create(:restaurant_user)
          other_user = create(:restaurant_user, email: 'other@email.com')
          other_restaurant = create(:restaurant, restaurant_user: other_user)
          login_as(user, scope: :restaurant_user)

          get edit_restaurant_path(other_restaurant)

          expect(response).to have_http_status(302)
          expect(response).to redirect_to(new_restaurant_path)
          expect(flash[:alert]).to eq "Cadastre seu restaurante para continuar"
          expect(flash[:notice]).to be_nil
        end
      end
    end
  end
end
