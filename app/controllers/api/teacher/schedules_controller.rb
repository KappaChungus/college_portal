module Api
  module Teacher
    class SchedulesController < BaseController
      # GET /api/teacher/schedule
      def schedule
  unless current_user.is_a?(::Teacher)
          render json: { error: "Access denied" }, status: :forbidden and return
  end

        sessions = Schedule.where(teacher: current_user).includes(:course, :group).order(:day_of_week, :start_time)

        grouped = sessions.group_by(&:day_of_week).transform_values do |arr|
          arr.map do |s|
            s.as_json(only: [ :id, :day_of_week, :start_time, :end_time, :room ])
             .merge(
               course: s.course.as_json(only: [ :id, :code, :title ]),
               group: s.group&.as_json(only: [ :id, :name ])
             )
          end
        end

        render json: grouped
      end

      private
    end
  end
end
