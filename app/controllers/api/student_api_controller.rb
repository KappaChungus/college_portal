
module Api
  class StudentApiController < ApplicationController
    before_action :authenticate_user!
    before_action :require_student

    def courses
      student_courses = current_user.becomes(Student)
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

    def groups
      student = current_user.becomes(Student)
      groups = student.groups.distinct

      render json: groups.as_json(only: [ :id, :name ])
    end

    # (moved to SurveysApiController)

    # GET /api/student/profile
    def profile
      student = current_user.becomes(Student)
      profile = student.student_profile

      if profile
        render json: profile.as_json(only: [ :id, :study_name, :study_year, :semester, :specialization_field ])
      else
        render json: {}, status: :not_found
      end
    end


    private

    def require_student
      render json: { error: "Access denied" }, status: :forbidden unless current_user.is_a?(Student)
    end

    def student_profile_params
      params.require(:student_profile).permit(:study_name, :study_year, :semester, :specialization_field)
    end
  end
end
