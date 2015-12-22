require "rails_helper"

describe Users::OmniauthCallbacksController, type: :controller do
  describe "registration on website through vkontakte account" do
    let(:uid) { generate(:uid) }
    let(:mock_auth_hash) { vk_mock_auth_hash }
    let(:email) { mock_auth_hash.info.email }
    let(:user) { FactoryGirl.create(:user, :vk_user, vkontakte_uid: uid) }
    let(:ops) { { vkontakte_uid: user.vkontakte_uid } }

    it_behaves_like "registration_through_social"
  end
end
