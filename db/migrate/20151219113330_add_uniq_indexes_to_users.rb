class AddUniqIndexesToUsers < ActiveRecord::Migration
  def change
    add_index :users, :vkontakte_url, unique: true
    add_index :users, :vkontakte_username, unique: true
    add_index :users, :vkontakte_uid, unique: true
    add_index :users, :vkontakte_nickname, unique: true
    add_index :users, :facebook_url, unique: true
    add_index :users, :facebook_username, unique: true
    add_index :users, :facebook_uid, unique: true
  end
end
