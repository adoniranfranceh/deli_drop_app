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
        expect(flash[:alert]).to match(/Para continuar, efetue login ou registre-se./)
      end

      it 'when restaurant_user already has a restaurant' do
        user = create(:restaurant_user)
        create(:restaurant, restaurant_user: user)
        login_as user, scope: :restaurant_user

        get new_restaurant_path

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(edit_restaurant_path user.restaurant)
        expect(flash[:alert]).to match(/Você já possui um restaurante cadastrado/)
      end
    end
  end
end
