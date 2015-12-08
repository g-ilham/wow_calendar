require "rails_helper"

describe Users::OmniauthCallbacksController, type: :controller do

  describe "facebook" do
    let(:email) { fc_mock_auth_hash.info.email }
    let(:facebook_uid) { fc_mock_auth_hash.uid }
    let(:user) { FactoryGirl.create(:user, :fc_user) }

    context "with a new facebook user which is not completed registration" do
      before do
        generate_request_in_callback
      end

      it do
        expect(User.count).to be(1)
        expect(response).to redirect_to(users_complete_registrations_path(user: { email: email }))
        expect(response).to have_http_status(302)
      end
    end

    context "with a new facebook user which is not completed registration" do
      let(:finded_user) { User.where(facebook_uid: facebook_uid) }

      before do
        user
        generate_request_in_callback
      end

      it do
        expect(User.count).to be(1)
        expect(user.facebook_uid).to match(facebook_uid)
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(302)
      end
    end
  end

  private

  def generate_request_in_callback
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = fc_mock_auth_hash
    get :facebook
  end
end
