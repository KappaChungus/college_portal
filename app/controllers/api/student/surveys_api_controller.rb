module Api
  module Student
  class SurveysApiController < BaseController
      # GET /api/student/current_teachers
      def current_teachers
  student = current_user.becomes(::Student)

        student_courses = student.student_courses
                                .includes(:teacher, :course)
                                .where(status: "current")

        result = student_courses.map do |sc|
          next unless sc.teacher

          {
            teacher: sc.teacher.as_json(only: [ :id, :name, :email ]),
            rated: sc.respond_to?(:rated) ? !!sc.rated : false,
            subject: sc.course&.title || sc.course&.code
          }
        end.compact

        render json: result
      end

      # GET /api/student/teachers/:teacher_id/rated
      def teacher_rated
  student = current_user.becomes(::Student)

  teacher = User.find_by(id: params[:teacher_id])
  unless teacher&.is_a?(::Teacher)
          return render json: { error: "Teacher not found" }, status: :not_found
  end

        rated = false
        if StudentCourse.column_names.include?("rated")
          rated = StudentCourse.where(student_id: student.id, teacher_id: teacher.id, rated: true).exists?
        else
          rated = Survey.joins(:student_course).where(teacher_id: teacher.id, student_courses: { student_id: student.id }).exists?
        end

        render json: { rated: !!rated }
      end

      # POST /api/student/surveys
      # Params: { survey: { student_course_id: int, quality_of_classes_conducted: int, ease_of_communication: int, fair_and_clear_conditions: int, detailed_opinion: string (optional) } }
      def create
  student = current_user.becomes(::Student)

        survey_params = params.require(:survey).permit(:student_course_id, :quality_of_classes_conducted, :ease_of_communication, :fair_and_clear_conditions, :detailed_opinion)

        sc = StudentCourse.find_by(id: survey_params[:student_course_id], student_id: student.id)
        return render json: { error: "Student course not found" }, status: :not_found unless sc

        unless sc.teacher
          return render json: { error: "No teacher assigned to this student course" }, status: :unprocessable_entity
        end

        # Check already rated
        if StudentCourse.column_names.include?("rated")
          if sc.rated
            return render json: { error: "Teacher already rated for this course" }, status: :unprocessable_entity
          end
        else
          if Survey.joins(:student_course).where(teacher_id: sc.teacher_id, student_courses: { student_id: student.id, id: sc.id }).exists?
            return render json: { error: "Teacher already rated for this course" }, status: :unprocessable_entity
          end
        end

        begin
          Survey.transaction do
            survey = Survey.create!(teacher: sc.teacher, student_course: sc)

            detail_attrs = {
              quality_of_classes_conducted: survey_params[:quality_of_classes_conducted],
              ease_of_communication: survey_params[:ease_of_communication],
              fair_and_clear_conditions: survey_params[:fair_and_clear_conditions],
              detailed_opinion: survey_params[:detailed_opinion]
            }

            survey.create_survey_detail!(detail_attrs)

            if StudentCourse.column_names.include?("rated")
              sc.update!(rated: true)
            end

            render json: { success: true, survey_id: survey.id }, status: :created
          end
        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/student/surveys
      def index
  student = current_user.becomes(::Student)

        surveys = Survey.joins(:student_course).where(student_courses: { student_id: student.id }).includes(:survey_detail, :teacher).order(created_at: :desc)

        result = surveys.map do |s|
          {
            id: s.id,
            teacher: s.teacher&.as_json(only: [ :id, :name, :email ]),
            created_at: s.created_at,
            detail: s.survey_detail&.as_json(only: [ :quality_of_classes_conducted, :ease_of_communication, :fair_and_clear_conditions, :detailed_opinion ])
          }
        end

        render json: result
      end

      private
  end
  end
end
