StudentCourse.destroy_all
CourseTeacher.destroy_all
Course.destroy_all
StudentProfile.destroy_all
User.destroy_all
Schedule.destroy_all
Group.destroy_all

puts "Creating Groups..."
groups = []
5.times do |i|
  groups << Group.create!(name: "Group #{i + 1}")
end

puts "Creating Teachers..."
teachers = []
3.times do |i|
  teachers << User.create!(
    name: "Teacher #{i + 1}",
    email: "teacher#{i + 1}@example.com",
    password: "password",
    type: "Teacher",
    group: groups.sample
  )
end

puts "Creating Students..."
students = []
20.times do |i|
  students << User.create!(
    name: "Student #{i + 1}",
    email: "student#{i + 1}@example.com",
    password: "password",
    type: "Student",
    group: groups.sample
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
  courses.sample(2).each do |course|
    StudentCourse.create!(
      student: student,
      course: course,
      teacher: teachers.sample,
      grades: [
        { assignment: "Midterm", score: rand(50..100) },
        { assignment: "Final", score: rand(50..100) }
      ],
      final_grade: rand(50..100),
      status: [ "current", "passed", "failed" ].sample,  # fixed allowed values
      retaken: [ true, false ].sample,
      group_code: student.group.name
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

    # check overlap
    overlap = Schedule.where(group: group, day_of_week: day)
                      .where("start_time < ? AND end_time > ?", end_time, start_time)
    next if overlap.exists?

    session = Schedule.new(group: group, course: course, day_of_week: day, start_time: start_time, end_time: end_time, teacher: course.teacher)
    if session.save
      created += 1
    end
  end
end

puts "Seeding schedules completed!"
