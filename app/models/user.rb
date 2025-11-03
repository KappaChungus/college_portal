class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # If the user is a teacher
  has_many :courses, foreign_key: "teacher_id", dependent: :destroy

  # If the user is a student
  has_many :enrollments, foreign_key: "user_id"
  has_many :enrolled_courses, through: :enrollments, source: :course

  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end
end
