class ChangeRepeatTypeToEvents < ActiveRecord::Migration
  def change
    change_column :events, :repeat_type, :string, default: "not_repeat"
  end
end
