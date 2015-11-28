class AddIndexesToEvents < ActiveRecord::Migration
  def change
    add_index :events, :user_id
    add_index :events, :parent_id
  end
end
