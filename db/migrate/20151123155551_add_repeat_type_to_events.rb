class AddRepeatTypeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :repeat_type, :string
  end
end
