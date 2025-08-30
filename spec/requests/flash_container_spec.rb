require 'rails_helper'

RSpec.describe FlashController, type: :request do
  let(:restaurant_user) { create(:restaurant_user) }

  before do
    login_as(restaurant_user, scope: :restaurant_user)
  end

  describe "GET /flash" do
    let(:path) { "/" }

    context "when notice and alert params are present" do
      it "sets flash notice and alert and redirects to the given path" do
        get "/flash", params: { path: path, notice: "Success!", alert: "Something went wrong" }

        expect(flash[:notice]).to eq("Success!")
        expect(flash[:alert]).to eq("Something went wrong")
        expect(response).to redirect_to(path)
      end
    end

    context "when only notice param is present" do
      it "sets only flash notice and redirects" do
        get "/flash", params: { path: path, notice: "Success!" }

        expect(flash[:notice]).to eq("Success!")
        expect(flash[:alert]).to be_nil
        expect(response).to redirect_to(path)
      end
    end

    context "when only alert param is present" do
      it "sets only flash alert and redirects" do
        get "/flash", params: { path: path, alert: "Something went wrong" }

        expect(flash[:alert]).to eq("Something went wrong")
        expect(flash[:notice]).to be_nil
        expect(response).to redirect_to(path)
      end
    end

    context "when no path param is given" do
      it "redirects to root path" do
        get "/flash"

        expect(flash[:alert]).to be_nil
        expect(flash[:notice]).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
