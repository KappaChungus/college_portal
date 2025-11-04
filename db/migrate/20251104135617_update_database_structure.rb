class UpdateDatabaseStructure < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.timestamps
    end

    change_table :users do |t|
      t.string :type
      t.references :group, foreign_key: true
    end

    change_table :courses do |t|
      t.references :group, foreign_key: true
    end

    create_table :course_teachers do |t|
      t.references :course, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    create_table :student_courses do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :course, null: false, foreign_key: true

      t.string :status, null: false, default: "current"
      t.float :final_grade
      t.json :grades, default: []
      t.boolean :retaken, default: false
      t.string :group_code
      t.references :teacher, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
