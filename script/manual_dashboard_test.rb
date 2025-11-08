#!/usr/bin/env ruby
# Test script to demonstrate teacher creating announcements and student viewing them

require_relative "../config/environment"

puts "=== Testing Announcements and Grades ==="
puts

# Get a teacher and student
teacher = User.where(type: "Teacher").first
student = User.where(type: "Student").first

puts "Teacher: #{teacher.name} (#{teacher.email})"
puts "Student: #{student.name} (#{student.email})"
puts

# Teacher creates an announcement
puts "1. Teacher creates an announcement..."
announcement = Announcement.create!(
  teacher: teacher,
  title: "Important: Final Exam Schedule",
  content: "The final exam will be held on December 15th at 10:00 AM. Please arrive 15 minutes early.",
  date: Date.today
)
puts "   ✓ Created announcement: '#{announcement.title}'"
puts

# Show all announcements (what student would see)
puts "2. Student views announcements..."
announcements = Announcement.recent.limit(5)
announcements.each do |ann|
  puts "   - #{ann.date}: #{ann.title}"
  puts "     By: #{ann.teacher.name}"
  puts "     Content: #{ann.content[0..60]}..."
  puts
end

# Show student's latest grades
puts "3. Student views latest grades..."
student_courses = StudentCourse.includes(:course)
                                .where(student: student)
                                .where.not(grades: [])
                                .limit(3)

all_grades = []
student_courses.each do |sc|
  next if sc.grades.blank?

  sc.grades.each do |grade|
    all_grades << {
      course: "#{sc.course.code} - #{sc.course.title}",
      name: grade["name"] || "Test",
      mark: grade["mark"] || 0,
      date: grade["created_at"]
    }
  end
end

latest_grades = all_grades.sort_by { |g| g[:date] }.reverse.take(5)

if latest_grades.any?
  latest_grades.each do |grade|
    puts "   - #{grade[:course]}"
    puts "     #{grade[:name]}: #{grade[:mark]}/20"
    puts
  end
else
  puts "   No grades found"
end

puts "=== Test Complete ==="
