module Api
  module Student
    class SchedulesController < BaseController
      # GET /api/student/schedule
      def index
        unless current_user.is_a?(::Student)
          render json: { error: "Access denied" }, status: :forbidden and return
        end

        group = current_user.group
        unless group
          render json: {}, status: :not_found and return
        end

        sessions = Schedule.where(group: group).includes(:course, :teacher).order(:day_of_week, :start_time)

        grouped = sessions.group_by(&:day_of_week).transform_values do |arr|
          arr.map do |s|
            s.as_json(only: [ :id, :day_of_week, :start_time, :end_time, :room ])
             .merge(
               course: s.course.as_json(only: [ :id, :code, :title ]),
               teacher: s.teacher&.as_json(only: [ :id, :name, :email ])
             )
          end
        end

        render json: grouped
      end

      private
    end
  end
end
