module Api
  module Teacher
    class ProfileController < BaseController
      # GET /api/teacher/profile
      def show
        teacher = current_user.becomes(::Teacher)
        groups = teacher.groups.distinct

        render json: {
          id: teacher.id,
          name: teacher.name,
          email: teacher.email,
          science_title: teacher.science_title,
          groups: groups.as_json(only: [ :id, :name ])
        }
      end

      # GET /api/teacher/profile/stats
      def stats
        teacher = current_user.becomes(::Teacher)

        # Count total courses the teacher is responsible for
        total_courses = teacher.courses.distinct.count

        # Count total unique students enrolled in teacher's courses
        total_students = StudentCourse.where(teacher_id: teacher.id)
                                      .select(:student_id)
                                      .distinct
                                      .count

        render json: {
          total_courses: total_courses,
          total_students: total_students
        }
      end

      private

      def profile_params
        params.require(:profile).permit(:name, :science_title)
      end
    end
  end
end
