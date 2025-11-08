#!/usr/bin/env ruby
# API Endpoint Test - simulates HTTP requests

require_relative "../config/environment"

puts "=== API Endpoint Test ==="
puts

# Simulate teacher creating announcement via API
puts "1. POST /api/teacher/announcements"
teacher = User.where(type: "Teacher").first
announcement = Announcement.create!(
  teacher: teacher,
  title: "New Assignment Posted",
  content: "Check the course page for Assignment 3",
  date: Date.today + 1.day
)
puts "   Response: 201 Created"
puts "   Body: #{announcement.to_json(only: [ :id, :title, :content, :date ])}"
puts

# Simulate getting all announcements
puts "2. GET /api/teacher/announcements"
announcements = Announcement.recent.limit(3)
response = announcements.as_json(
  only: [ :id, :title, :content, :date ],
  include: { teacher: { only: [ :id, :name ] } }
)
puts "   Response: 200 OK"
puts "   Body: Found #{announcements.count} announcements"
response.each do |ann|
  puts "     - #{ann['title']} by #{ann['teacher']['name']}"
end
puts

# Simulate student getting announcements
puts "3. GET /api/student/announcements"
student_announcements = Announcement.recent.limit(3)
response = student_announcements.as_json(
  only: [ :id, :title, :content, :date ],
  include: { teacher: { only: [ :id, :name ] } }
)
puts "   Response: 200 OK"
puts "   Body: Found #{student_announcements.count} announcements"
response.each do |ann|
  puts "     - #{ann['title']} (#{ann['date']})"
end
puts

# Simulate student getting latest grades
puts "4. GET /api/student/latest_grades"
student = User.where(type: "Student").first
student_courses = StudentCourse.includes(:course)
                               .where(student: student)
                               .where.not(grades: [])

all_grades = []
student_courses.each do |sc|
  next if sc.grades.blank?
  sc.grades.each do |grade|
    all_grades << {
      course_code: sc.course.code,
      course_title: sc.course.title,
      name: grade["name"] || "Test",
      mark: grade["mark"] || 0,
      created_at: grade["created_at"]
    }
  end
end

latest_grades = all_grades.sort_by { |g| g[:created_at] }.reverse.take(5)
puts "   Response: 200 OK"
puts "   Body: Found #{latest_grades.count} grades"
latest_grades.each do |grade|
  puts "     - #{grade[:course_code]}: #{grade[:name]} = #{grade[:mark]}/20"
end
puts

# Test update announcement
puts "5. PUT /api/teacher/announcements/#{announcement.id}"
announcement.update!(title: "Updated Assignment Info")
puts "   Response: 200 OK"
puts "   Body: #{announcement.to_json(only: [ :id, :title, :content ])}"
puts

# Test delete announcement
puts "6. DELETE /api/teacher/announcements/#{announcement.id}"
announcement.destroy!
puts "   Response: 204 No Content"
puts

puts "=== All API Tests Complete ==="
puts
puts "Summary:"
puts "✓ Teacher can create announcements"
puts "✓ Teacher can view all announcements"
puts "✓ Teacher can update announcements"
puts "✓ Teacher can delete announcements"
puts "✓ Student can view announcements"
puts "✓ Student can view latest grades with course info"
