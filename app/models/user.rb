class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  self.inheritance_column = :type
  validates :name, presence: true
  has_many :student_courses, foreign_key: :student_id, dependent: :destroy
end
