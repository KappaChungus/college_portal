module Api
  module Teacher
    class DashboardController < BaseController
      # GET /api/teacher/announcements
      def announcements
        teacher = current_user.becomes(::Teacher)
        announcements = Announcement.recent

        render json: announcements.as_json(
          only: [ :id, :title, :content, :date, :created_at, :updated_at ],
          include: {
            teacher: { only: [ :id, :name ] }
          }
        )
      end

      # POST /api/teacher/announcements
      def create_announcement
        teacher = current_user.becomes(::Teacher)
        announcement = teacher.announcements.build(announcement_params)

        if announcement.save
          render json: announcement.as_json(
            only: [ :id, :title, :content, :date, :created_at, :updated_at ]
          ), status: :created
        else
          render json: { errors: announcement.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/teacher/announcements/:id
      def update_announcement
        teacher = current_user.becomes(::Teacher)
        announcement = teacher.announcements.find(params[:id])

        if announcement.update(announcement_params)
          render json: announcement.as_json(
            only: [ :id, :title, :content, :date, :created_at, :updated_at ]
          )
        else
          render json: { errors: announcement.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Announcement not found" }, status: :not_found
      end

      # DELETE /api/teacher/announcements/:id
      def delete_announcement
        teacher = current_user.becomes(::Teacher)
        announcement = teacher.announcements.find(params[:id])

        announcement.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Announcement not found" }, status: :not_found
      end

      private

      def announcement_params
        params.require(:announcement).permit(:title, :content, :date)
      end
    end
  end
end
