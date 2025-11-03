puts "Seeding the database..."

# Clean existing data (optional during dev)
User.destroy_all
Course.destroy_all
Enrollment.destroy_all
teachers = [
  { name: "Alice Johnson", email: "alice@uni.edu", role: "teacher", password: "password" },
  { name: "Bob Smith", email: "bob@uni.edu", role: "teacher", password: "password" }
]

teachers.each do |teacher_data|
  User.create!(teacher_data)
end

students = [
  { name: "Charlie Brown", email: "charlie@student.edu", role: "student", password: "password" },
  { name: "Diana Prince", email: "diana@student.edu", role: "student", password: "password" },
  { name: "Ethan Hunt", email: "ethan@student.edu", role: "student", password: "password" }
]

students.each do |student_data|
  User.create!(student_data)
end

courses = [
  { title: "Intro to Computer Science", code: "CS101", teacher: User.find_by(email: "alice@uni.edu") },
  { title: "Advanced Mathematics", code: "MATH201", teacher: User.find_by(email: "bob@uni.edu") }
]
courses.each do |course_data|
  Course.create!(course_data)
end


Course.all.each do |course|
  User.where(role: 'student').sample(2).each do |student|
    Enrollment.create!(student: student, course: course)
  end
end
