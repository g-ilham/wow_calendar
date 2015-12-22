class ChangeTitleColumnToEvents < ActiveRecord::Migration
  def change
    change_column :events, :title, :string, null: false
  end
end
