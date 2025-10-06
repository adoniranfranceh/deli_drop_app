require 'rails_helper'

describe 'User access new form path' do
  context 'GET /restaurants/new' do
    it 'successfully' do
      user = create(:restaurant_user)
      login_as user, scope: :restaurant_user

      get new_restaurant_path

      expect(response).to have_http_status(200)
    end

    context 'cannot access' do
      it 'when not logged in' do
        get new_restaurant_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_restaurant_user_session_path)
        expect(flash[:alert]).to eq "Para continuar, efetue login ou registre-se."
      end

      it 'when restaurant_user already has a restaurant' do
        user = create(:restaurant_user)
        create(:restaurant, restaurant_user: user)
        login_as user, scope: :restaurant_user

        get new_restaurant_path

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq "Você não tem permissão para executar esta ação"
      end
    end
  end
end
