require "rails_helper"

describe Users::OmniauthCallbacksController, type: :controller do

  describe "vkontakte" do
    let(:email) { vk_mock_auth_has.info.email }
    let(:vkontakte_uid) { vk_mock_auth_has.uid }
    let(:user) { FactoryGirl.create(:user, :vk_user) }

    context "with a new vkontakte user which is not completed registration" do
      before do
        generate_request_in_callback
      end

      it do
        expect(User.count).to be(1)
        expect(response).to redirect_to(users_complete_registrations_path(user: { email: email }))
        expect(response).to have_http_status(302)
      end
    end

    context "with a new vkontakte user which is not completed registration" do
      let(:finded_user) { User.where(vkontakte_uid: vkontakte_uid) }

      before do
        user
        generate_request_in_callback
      end

      it do
        expect(User.count).to be(1)
        expect(user.vkontakte_uid).to match(vkontakte_uid)
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(302)
      end
    end
  end

  private

  def generate_request_in_callback
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = vk_mock_auth_has
    get :vkontakte
  end
end
