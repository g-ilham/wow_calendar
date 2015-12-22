class ChangeUserIdColumnToEvents < ActiveRecord::Migration
  def change
    change_column :events, :user_id, :integer, null: false
    add_foreign_key :events, :users
  end
end
