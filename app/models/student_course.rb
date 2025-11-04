class StudentCourse < ApplicationRecord
  belongs_to :student, class_name: "User", foreign_key: :student_id
  belongs_to :teacher, class_name: "User", optional: true
  belongs_to :course

  validates :status, presence: true, inclusion: { in: %w[current passed failed] }

  validates :status, presence: true
end