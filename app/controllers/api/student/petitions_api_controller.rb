module Api
  module Student
    class PetitionsApiController < BaseController
      # GET /api/student/petitions
      def my_petitions
        student = current_user.becomes(::Student)

        petitions = Petition.where(student_id: student.id).order(created_at: :desc)

        render json: petitions.as_json(only: [ :id, :topic, :petition_content, :status, :created_at, :updated_at ])
      end

      # GET /api/student/topics
      def topics
        student = current_user.becomes(::Student)
        topics = Petition::TOPICS

        render json: topics
      end

      # POST /api/student/petitions
      def create
        student = current_user.becomes(::Student)

        p_params = params.require(:petition).permit(:topic, :petition_content)

        petition = Petition.new(student_id: student.id, topic: p_params[:topic], petition_content: p_params[:petition_content])

        if petition.save
            # enqueue notification email to admin/registry
            begin
              PetitionMailer.new_petition(petition).deliver_later
            rescue StandardError => e
              Rails.logger.error("Failed to enqueue petition email: ")
              Rails.logger.error(e.message)
            end

          render json: petition.as_json(only: [ :id, :topic, :petition_content, :status, :created_at ]), status: :created
        else
          render json: { errors: petition.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private
    end
  end
end
