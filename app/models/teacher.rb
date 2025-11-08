class Teacher < User
  has_many :courses, foreign_key: "teacher_id", dependent: :destroy
  has_many :groups, through: :courses
  has_many :announcements, foreign_key: "teacher_id", dependent: :destroy
end
