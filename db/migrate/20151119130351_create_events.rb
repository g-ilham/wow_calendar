class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.integer :starts_at, null: false
      t.integer :ends_at
      t.integer :user_id
      t.boolean :all_day, default: false

      t.timestamps null: false
    end
  end
end
