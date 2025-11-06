module Api
  class SchedulesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group, only: [ :index, :create ]

    # GET /api/groups/:group_id/schedule
    def index
      sessions = Schedule.where(group: @group).includes(:course, :teacher).order(:day_of_week, :start_time)

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

    # GET /api/student/schedule
    def student_schedule
      unless current_user.is_a?(Student)
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

    # POST /api/groups/:group_id/schedule
    def create
      session = Schedule.new(schedule_params.merge(group: @group))

      if session.save
        render json: session.as_json(only: [ :id, :day_of_week, :start_time, :end_time, :room ]), status: :created
      else
        render json: { errors: session.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/schedules/:id
    def update
      session = Schedule.find(params[:id])

      if session.update(schedule_params)
        render json: session.as_json(only: [ :id, :day_of_week, :start_time, :end_time, :room ])
      else
        render json: { errors: session.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/schedules/:id
    def destroy
      session = Schedule.find(params[:id])
      session.destroy
      head :no_content
    end

    private

    def set_group
      @group = Group.find_by(id: params[:group_id])
      render json: { error: "Group not found" }, status: :not_found unless @group
    end

    def schedule_params
      params.require(:schedule).permit(:course_id, :teacher_id, :day_of_week, :start_time, :end_time, :room)
    end
  end
end
