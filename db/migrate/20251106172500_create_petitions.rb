class CreatePetitions < ActiveRecord::Migration[8.1]
  def change
    create_table :petitions do |t|
      t.integer :student_id, null: false
      t.string :topic, null: false
      t.text :petition_content, null: false
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :petitions, :student_id
    add_foreign_key :petitions, :users, column: :student_id
  end
end
