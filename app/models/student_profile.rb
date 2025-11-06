class StudentProfile < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  # optional: validate study_year numericality when present
  validates :study_year, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
