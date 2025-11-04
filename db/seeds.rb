StudentCourse.destroy_all
Enrollment.destroy_all
CourseTeacher.destroy_all
Course.destroy_all
User.destroy_all
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
    Enrollment.create!(
      student: student,  # fixed from user: to student:
      course: course,
      grade: [ "A", "B", "C", "D", "F" ].sample
    )
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
