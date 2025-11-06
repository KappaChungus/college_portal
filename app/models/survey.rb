class Survey < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :student_course
  has_one :survey_detail, dependent: :destroy

  validates :teacher, presence: true
  validates :student_course, presence: true

  # helper to delegate detail fields
  delegate :quality_of_classes_conducted, :ease_of_communication, :fair_and_clear_conditions, :detailed_opinion, to: :survey_detail, allow_nil: true
end
