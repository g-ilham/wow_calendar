class RemoveStartsAtAndEndsAtColumnsInEvents < ActiveRecord::Migration
  def change
    remove_column :events, :starts_at
    remove_column :events, :ends_at
  end
end
