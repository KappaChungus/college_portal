class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User", optional: true
  belongs_to :group, optional: true

  has_many :course_teachers, class_name: "CourseTeacher", foreign_key: "course_id", dependent: :destroy
  has_many :teachers, through: :course_teachers, source: :teacher

  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :student
end
