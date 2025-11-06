class CreateClassSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :class_sessions do |t|
      t.references :group, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :teacher, foreign_key: { to_table: :users }
      t.integer :day_of_week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :room

      t.timestamps
    end

    add_index :class_sessions, [ :group_id, :day_of_week, :start_time ], name: "index_class_sessions_on_group_day_start"
  end
end
