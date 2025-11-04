
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

    private

    def require_student
      render json: { error: "Access denied" }, status: :forbidden unless current_user.is_a?(Student)
    end
  end
end
