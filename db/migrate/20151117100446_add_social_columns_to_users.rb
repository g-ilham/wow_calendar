class AddSocialColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vkontakte_url, :string
    add_column :users, :vkontakte_username, :string
    add_column :users, :vkontakte_uid, :string
    add_column :users, :vkontakte_nickname, :string
    add_column :users, :facebook_url, :string
    add_column :users, :facebook_username, :string
    add_column :users, :facebook_uid, :string
  end
end
