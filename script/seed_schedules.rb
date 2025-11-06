# Simple schedule seeding script
puts "Seeding schedules via runner..."

time_slots = [
  [ '08:00', '09:30' ],
  [ '09:45', '11:15' ],
  [ '11:30', '13:00' ],
  [ '13:30', '15:00' ],
  [ '15:15', '16:45' ]
]

groups_created = 0
Group.find_each do |group|
  group_courses = Course.where(group: group).to_a
  next if group_courses.empty?

  # remove existing schedules for idempotency
  Schedule.where(group: group).destroy_all

  days = [ 1, 2, 3, 4, 5 ]
  created = 0
  attempts = 0
  while created < 5 && attempts < 50
    attempts += 1
    course = group_courses.sample
    day = days.sample
    slot = time_slots.sample
    start_time, end_time = slot

    overlap = Schedule.where(group: group, day_of_week: day)
                      .where("start_time < ? AND end_time > ?", end_time, start_time)
    next if overlap.exists?

    session = Schedule.new(group: group, course: course, day_of_week: day, start_time: start_time, end_time: end_time, teacher: course.teacher)
    if session.save
      created += 1
    else
      # skip and try again
      # puts "Skipped: "+session.errors.full_messages.join(', ')
      next
    end
  end
  groups_created += 1
end

puts "Seeded schedules for "+groups_created.to_s+" groups"
