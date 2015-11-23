class AddSomeColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :in_fifteen_minutes, :boolean, default: false
    add_column :users, :in_hour, :boolean, default: false
    add_column :users, :in_day, :boolean, default: false
  end
end
