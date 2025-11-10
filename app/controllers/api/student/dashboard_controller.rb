module Api
  module Student
    class DashboardController < BaseController
      # GET /api/student/announcements
      def announcements
        announcements = Announcement.recent.limit(10)

        render json: announcements.as_json(
          only: [ :id, :title, :content, :date, :created_at, :updated_at ],
          include: {
            teacher: { only: [ :id, :name ] }
          }
        )
      end

      # GET /api/student/latest_grades
      def latest_grades
        student_courses = current_student.student_courses
                                 .includes(:course)
                                 .where.not(grades: [])

        all_grades = []

        student_courses.each do |sc|
          next if sc.grades.blank?

          sc.grades.each do |grade|
            all_grades << {
              course_code: sc.course.code,
              course_title: sc.course.title,
              name: grade["name"] || grade["assignment"] || "Test",
              mark: grade["mark"] || grade["score"] || 0,
              created_at: grade["created_at"] || sc.created_at
            }
          end
        end
        latest_grades = all_grades.sort_by { |g| g[:created_at] }.reverse.take(5)

        render json: latest_grades
      end
    end
  end
end
