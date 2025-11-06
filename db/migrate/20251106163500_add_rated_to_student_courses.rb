class AddRatedToStudentCourses < ActiveRecord::Migration[8.1]
  def change
    add_column :student_courses, :rated, :boolean, default: false, null: false
    add_index :student_courses, :rated
  end
end
