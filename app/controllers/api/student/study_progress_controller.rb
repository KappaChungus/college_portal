
module Api
  module Student
    class StudyProgressController < BaseController
      # GET /api/student/courses

      def courses
        student_courses = current_user.becomes(::Student)
                                      .student_courses
                                      .includes(:course, :teacher)

        render json: student_courses.as_json(
          include: {
            course: { only: [ :id, :code, :title ] },
            teacher: { only: [ :id, :name, :email ] }
          },
          only: [ :id, :final_grade, :grades, :status, :retaken, :group_code ]
        )
      end

      # GET /api/student/profile/groups
      def groups
        student = current_user.becomes(::Student)
        groups = student.groups.distinct

        render json: groups.as_json(only: [ :id, :name ])
      end

      # GET /api/student/profile
      def profile
        student = current_user.becomes(::Student)
        profile = student.student_profile

        if profile
          render json: profile.as_json(only: [ :id, :study_name, :study_year, :semester, :specialization_field ])
        else
          render json: {}, status: :not_found
        end
      end

      # GET /api/student/courses/:course_id/grades
      def grades
        student = current_user.becomes(::Student)
        student_course = student.student_courses.find_by(course_id: params[:course_id])

        if student_course
          render json: {
            course_id: student_course.course_id,
            final_grade: student_course.final_grade,
            grades: student_course.grades || [],
            status: student_course.status,
            course: student_course.course.as_json(only: [ :id, :code, :title ])
          }
        else
          render json: { error: "Course not found or not enrolled" }, status: :not_found
        end
      end


      private

      def student_profile_params
        params.require(:student_profile).permit(:study_name, :study_year, :semester, :specialization_field)
      end
    end
  end
end
