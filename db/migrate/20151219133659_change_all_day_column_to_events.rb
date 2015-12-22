class ChangeAllDayColumnToEvents < ActiveRecord::Migration
  def change
    change_column :events, :all_day, :boolean, null: false
  end
end
