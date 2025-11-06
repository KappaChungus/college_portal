class DropEnrollmentsTable < ActiveRecord::Migration[8.1]
  def up
    drop_table :enrollments, if_exists: true
  end

  def down
    create_table :enrollments do |t|
      t.references :course, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :grade
      t.timestamps
    end
    add_index :enrollments, :course_id
    add_index :enrollments, :user_id
  end
end
