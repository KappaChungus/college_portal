# Disable foreign key checks for SQLite
ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF")

# Clear all data
ActiveRecord::Base.connection.execute("DELETE FROM announcements")
ActiveRecord::Base.connection.execute("DELETE FROM schedules")
ActiveRecord::Base.connection.execute("DELETE FROM student_courses")
ActiveRecord::Base.connection.execute("DELETE FROM course_teachers")
ActiveRecord::Base.connection.execute("DELETE FROM courses")
ActiveRecord::Base.connection.execute("DELETE FROM student_profiles")
ActiveRecord::Base.connection.execute("DELETE FROM users")
ActiveRecord::Base.connection.execute("DELETE FROM groups")

# Re-enable foreign key checks
ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")

puts "Creating Groups..."
groups = []
5.times do |i|
  groups << Group.create!(name: "Group #{i + 1}")
end

puts "Creating Teachers..."
teachers = []
science_titles = [ "PhD", "MSc", "Prof.", "Dr.", "Assoc. Prof." ]
3.times do |i|
  teachers << User.create!(
    name: "Teacher #{i + 1}",
    email: "teacher#{i + 1}@example.com",
    password: "password",
    type: "Teacher",
    science_title: science_titles.sample
  )
end

puts "Creating Students..."
students = []
20.times do |i|
  students << User.create!(
    name: "Student #{i + 1}",
    email: "student#{i + 1}@example.com",
    password: "password",
    type: "Student"
  )
end

puts "Creating Student Profiles..."
study_names = [ "Computer Science", "Mathematics", "Physics", "Biology", "Economics" ]
specializations = [ "AI", "Networks", "Software Engineering", "Data Science", "Security" ]
semesters = [ 1, 2 ]

students.each do |student|
  # create profile only for student records (STI)
  next unless student.type == "Student"

  # skip if profile already exists (idempotent)
  next if student.student_profile.present?

  year = rand(1..4)
  semester = year * 2 - 1 + rand(0..1)

  student.create_student_profile!(
    study_name: study_names.sample,
    study_year: year,
    semester: semester,
    specialization_field: specializations.sample
  )
end

puts "Creating Courses..."
courses = []
10.times do |i|
  courses << Course.create!(
    code: "CSE#{100 + i}",
    title: "Course #{i + 1}",
    group: groups.sample,
    teacher: teachers.sample
  )
end

puts "Assigning Teachers to Courses..."
courses.each do |course|
  # Randomly assign 1-2 teachers per course
  teachers.sample(rand(1..2)).each do |teacher|
    CourseTeacher.create!(course: course, teacher: teacher)
  end
end

puts "Enrolling Students..."
students.each do |student|
  courses.sample(3).each do |course|
    # enrollment records are managed via student_courses; skip creating legacy enrollments
  end
end

puts "Creating StudentCourses..."
students.each do |student|
  # Each student enrolls in 5-6 courses
  num_courses = rand(5..6)
  selected_courses = courses.sample(num_courses)

  selected_courses.each_with_index do |course, index|
    # Generate 3-5 test grades for each student
    num_tests = rand(3..5)
    grades = []
    teacher_id = teachers.sample.id

    num_tests.times do |i|
      # Create grades with timestamps spread over the past few weeks
      created_time = Time.now.utc - rand(1..30).days - rand(0..23).hours

      grade = {
        "name" => "Test #{i + 1}",
        "mark" => rand(0..20),
        "added_by" => teacher_id,
        "created_at" => created_time
      }

      # Randomly add updated_at for some grades (simulating edits)
      if rand < 0.3
        grade["updated_at"] = created_time + rand(1..5).days
        grade["updated_by"] = teacher_id
      end

      grades << grade
    end

    # Ensure first 3-4 courses are "current" (active), remaining can be passed/failed
    possible_grades = [ 2.0, 3.0, 3.5, 4.0, 4.5, 5.0 ]

    if index < 3 || (index == 3 && rand < 0.5)
      # This course is current (no final grade yet)
      final_grade = nil
      status = "current"
    else
      # This course is completed (passed or failed)
      final_grade = possible_grades.sample
      status = final_grade == 2.0 ? "failed" : "passed"
    end

    StudentCourse.create!(
      student: student,
      course: course,
      teacher: teachers.sample,
      grades: grades,
      final_grade: final_grade,
      status: status,
      retaken: [ true, false ].sample,
      group_code: course.group&.name
    )
  end
end

puts "Seeding completed!"

puts "Seeding schedules..."
# Simple seeding: for each group, create up to 5 schedule entries avoiding overlaps
time_slots = [
  [ '08:00', '09:30' ],
  [ '09:45', '11:15' ],
  [ '11:30', '13:00' ],
  [ '13:30', '15:00' ],
  [ '15:15', '16:45' ]
]

Group.find_each do |group|
  # pick courses that belong to the group
  group_courses = Course.where(group: group).to_a
  next if group_courses.empty?

  days = [ 1, 2, 3, 4, 5 ] # Monday..Friday

  created = 0
  attempts = 0
  while created < 5 && attempts < 50
    attempts += 1
    course = group_courses.sample
    day = days.sample
    slot = time_slots.sample
    start_time, end_time = slot
    room_number = rand(100..500)

    # check overlap
    overlap = Schedule.where(group: group, day_of_week: day)
                      .where("start_time < ? AND end_time > ?", end_time, start_time)
    next if overlap.exists?

    session = Schedule.new(group: group, course: course, day_of_week: day, start_time: start_time, end_time: end_time, room: room_number.to_s, teacher: course.teacher)
    if session.save
      created += 1
    end
  end
end

puts "Seeding schedules completed!"

puts "Seeding announcements..."
# Create some announcements from teachers
announcement_titles = [
  "Exam Schedule Update",
  "Office Hours Changed",
  "Important: Project Deadline",
  "Guest Lecture Next Week",
  "Lab Session Cancelled",
  "New Study Materials Available",
  "Midterm Results Posted",
  "Assignment Submission Guidelines",
  "Course Material Update",
  "Final Exam Information"
]

announcement_contents = [
  "The exam schedule has been updated. Please check the schedule page for the latest information.",
  "My office hours for this week have been moved to Thursday 2-4 PM. Please plan accordingly.",
  "Reminder: The project deadline is approaching. Make sure to submit your work on time.",
  "We will have a guest lecturer next week discussing industry trends. Attendance is mandatory.",
  "Due to technical issues, today's lab session has been cancelled. We will reschedule soon.",
  "New study materials for the upcoming exam are now available on the course page.",
  "Midterm results have been posted. Please review your grades and contact me if you have questions.",
  "Please follow the submission guidelines carefully. Late submissions will not be accepted.",
  "Updated course materials are now available. Please download the latest version.",
  "Final exam details have been posted. The exam will cover all topics discussed this semester."
]

teachers.each do |teacher|
  # Each teacher creates 3-5 announcements
  rand(3..5).times do
    date_offset = rand(1..30).days
    announcement_date = Date.today - date_offset

    Announcement.create!(
      teacher: teacher,
      date: announcement_date,
      title: announcement_titles.sample,
      content: announcement_contents.sample
    )
  end
end

puts "Seeding announcements completed!"
