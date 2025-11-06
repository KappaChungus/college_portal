module Api
  class PetitionsApiController < ApplicationController
    before_action :authenticate_user!
    before_action :require_student

    # GET /api/student/petitions
    def my_petitions
      student = current_user.becomes(Student)

      petitions = Petition.where(student_id: student.id).order(created_at: :desc)

      render json: petitions.as_json(only: [ :id, :topic, :petition_content, :status, :created_at, :updated_at ])
    end

    # POST /api/student/petitions
    def create
      student = current_user.becomes(Student)

      p_params = params.require(:petition).permit(:topic, :petition_content)

      petition = Petition.new(student_id: student.id, topic: p_params[:topic], petition_content: p_params[:petition_content])

      if petition.save
        render json: petition.as_json(only: [ :id, :topic, :petition_content, :status, :created_at ]), status: :created
      else
        render json: { errors: petition.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def require_student
      render json: { error: "Access denied" }, status: :forbidden unless current_user.is_a?(Student)
    end
  end
end
