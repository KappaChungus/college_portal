class CreateAnnouncements < ActiveRecord::Migration[8.1]
  def change
    create_table :announcements do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.date :date, null: false
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :announcements, :date
  end
end
