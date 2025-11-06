class Petition < ApplicationRecord
  belongs_to :student, class_name: "User", foreign_key: "student_id"

  TOPICS = [
    "conditional promotion",
    "resignation from studies",
    "duplicate student ID",
    "other"
  ].freeze

  STATUSES = [
    "sent",
    "pending",
    "resolved"
    ].freeze

  validates :topic, presence: true, inclusion: { in: TOPICS }
  validates :petition_content, presence: true, length: { maximum: 10_000 }
  validates :status, presence: true, inclusion: { in: STATUSES }
end
