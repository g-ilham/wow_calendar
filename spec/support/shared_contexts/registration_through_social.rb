require 'rails_helper'
shared_context "registration_through_social" do
  context "new social user which is not completed registration" do
    before do
      generate_request_in_callback
    end

    it do
      expect(User.count).to eq(1)
      expect(response).to redirect_to(users_complete_registrations_path(user: { email: email }))
      expect(response).to have_http_status(302)
    end
  end

  context "persisted social user which is not completed registration" do
    let(:finded_user) { User.where(ops).first }

    before do
      user
      generate_request_in_callback
    end

    it do
      expect(User.count).to eq(1)
      expect(uid_in_db_user).to match(uid)
      expect(response).to redirect_to(root_path)
      expect(response).to have_http_status(302)
    end
  end

  private

  def uid_in_db_user
    finded_user.public_send(mock_auth_hash.provider + "_uid")
  end
end
