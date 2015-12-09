require "rails_helper"

describe Users::OmniauthCallbacksController, type: :controller do
  describe "registration on website through vkontakte account" do
    let(:email) { vk_mock_auth_hash.info.email }
    let(:user_uid) {  vk_mock_auth_hash.uid }
    let(:user) { FactoryGirl.create(:user, :vk_user) }
    let(:ops) { { vkontakte_uid: user_uid } }
    let(:provider_name) { "vkontakte" }

    it_behaves_like "registration_through_social"
  end
end
