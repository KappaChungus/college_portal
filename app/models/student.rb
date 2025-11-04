class Student < User
  has_many :enrollments, foreign_key: "user_id", dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :groups, through: :courses
end
