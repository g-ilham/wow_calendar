require "rails_helper"

describe Users::OmniauthCallbacksController, type: :controller do
  describe "registration on website through facebook account" do
    let(:uid) { generate(:uid) }
    let(:mock_auth_hash) { fc_mock_auth_hash }
    let(:email) { mock_auth_hash.info.email }
    let(:user) { FactoryGirl.create(:user, :fc_user, facebook_uid: uid) }
    let(:ops) { { facebook_uid: user.facebook_uid } }

    it_behaves_like "registration_through_social"
  end
end
