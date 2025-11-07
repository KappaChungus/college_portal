class Student < User
  has_many :student_courses, foreign_key: "student_id", dependent: :destroy
  has_many :courses, through: :student_courses
  has_one :student_profile, foreign_key: :user_id, dependent: :destroy

  delegate :study_name, :study_year, :semester, :specialization_field, to: :student_profile, allow_nil: true

  # Get distinct groups from student's courses
  def groups
    Group.joins(:courses).where(courses: { id: student_courses.select(:course_id) }).distinct
  end
end
