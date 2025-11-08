class Announcement < ApplicationRecord
  belongs_to :teacher, class_name: "Teacher", foreign_key: "teacher_id"

  validates :title, presence: true
  validates :content, presence: true
  validates :date, presence: true

  # Scope to get recent announcements
  scope :recent, -> { order(date: :desc, created_at: :desc) }
  scope :by_date, ->(date) { where(date: date) }
end
