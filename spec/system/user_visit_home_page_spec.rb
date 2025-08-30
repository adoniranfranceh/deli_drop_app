require 'rails_helper'

describe "User visits home page", js: true do
  it "needs to be logged in" do
    visit root_path

    expect(page).to have_current_path(new_restaurant_user_session_path)
    expect(page).to have_content("Para continuar, efetue login ou registre-se")
    expect(page).to have_content("Entrar")
  end

  it "successfully" do
    restaurant_user = create(:restaurant_user)
    login_as(restaurant_user, scope: :restaurant_user)
    restaurant_user.create_restaurant(name: "Hamburgueria Top")

    visit root_path
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Bem-vindo de volta, Hamburgueria Top")
  end
end
