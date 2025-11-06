class Student < User
  has_many :enrollments, foreign_key: "user_id", dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :groups, through: :courses
  has_one :student_profile, foreign_key: :user_id, dependent: :destroy

  delegate :study_name, :study_year, :semester, :specialization_field, to: :student_profile, allow_nil: true
end
