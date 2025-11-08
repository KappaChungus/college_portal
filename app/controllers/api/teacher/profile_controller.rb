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

      # PUT /api/teacher/profile
      def update
        teacher = current_user.becomes(::Teacher)

        if teacher.update(profile_params)
          groups = teacher.groups.distinct
          render json: {
            id: teacher.id,
            name: teacher.name,
            email: teacher.email,
            science_title: teacher.science_title,
            groups: groups.as_json(only: [ :id, :name ])
          }
        else
          render json: { errors: teacher.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.require(:profile).permit(:name, :science_title)
      end
    end
  end
end
