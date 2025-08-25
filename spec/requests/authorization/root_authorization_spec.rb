require "rails_helper"

RSpec.describe "Authorization - Root", type: :request do
  context "when user isn't authenticated" do
    it "redirect to login" do
      get root_path
      expect(response).to redirect_to(new_restaurant_user_session_path)
    end
  end

  context "when user is authenticated" do
    let(:user) { create(:restaurant_user) }

    before { sign_in user }

    it "allow access" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end
end
