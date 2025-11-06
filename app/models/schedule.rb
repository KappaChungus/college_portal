class Schedule < ApplicationRecord
  self.table_name = "schedules"

  belongs_to :group
  belongs_to :course
  belongs_to :teacher, class_name: "User", optional: true

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }
  validates :start_time, :end_time, presence: true
  validate :end_after_start
  validate :no_overlapping_sessions

  scope :for_group, ->(group_id) { where(group_id: group_id) }

  def end_after_start
    return unless start_time && end_time
    errors.add(:end_time, "must be after start_time") if end_time <= start_time
  end

  def no_overlapping_sessions
    return unless start_time && end_time && day_of_week && group_id

    overlap_query = Schedule.where(group_id: group_id, day_of_week: day_of_week)
                           .where.not(id: id)
                           .where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlap_query.exists?
      errors.add(:base, "Overlaps another session for this group")
    end

    if teacher_id.present?
      teacher_overlap = Schedule.where(teacher_id: teacher_id, day_of_week: day_of_week)
                                .where.not(id: id)
                                .where("start_time < ? AND end_time > ?", end_time, start_time)
      errors.add(:base, "Teacher has another session at this time") if teacher_overlap.exists?
    end

    if room.present?
      room_overlap = Schedule.where(room: room, day_of_week: day_of_week)
                             .where.not(id: id)
                             .where("start_time < ? AND end_time > ?", end_time, start_time)
      errors.add(:base, "Room is occupied at this time") if room_overlap.exists?
    end
  end
end
