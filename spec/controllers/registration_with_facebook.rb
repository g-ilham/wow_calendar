require "rails_helper"

describe Users::OmniauthCallbacksController, type: :controller do
  describe "registration on website through facebook account" do
    let(:email) { fc_mock_auth_hash.info.email }
    let(:user_uid) { fc_mock_auth_hash.uid }
    let(:user) { FactoryGirl.create(:user, :fc_user) }
    let(:ops) { { facebook_uid: user_uid } }
    let(:provider_name) { "facebook" }

    it_behaves_like "registration_through_social"
  end
end
