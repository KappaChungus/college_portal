module Api
  module Teacher
    class SurveysController < BaseController
      # GET /api/teacher/surveys
      # Returns all surveys for the current teacher and averages per metric
      def index
        teacher = current_user.becomes(::Teacher)

        surveys = Survey.where(teacher_id: teacher.id).includes(:survey_detail, student_course: :student).order(created_at: :desc)

        result = surveys.map do |s|
          {
            id: s.id,
            student_course_id: s.student_course_id,
            student: s.student_course&.student&.as_json(only: [ :id, :name, :email ]),
            created_at: s.created_at,
            detail: s.survey_detail&.as_json(only: [ :quality_of_classes_conducted, :ease_of_communication, :fair_and_clear_conditions, :detailed_opinion ])
          }
        end

        if result.count == 0
            render json: { error: "No surveys found" }, status: :not_found and return
        end

        avg_quality = Survey.joins(:survey_detail).where(teacher_id: teacher.id).average("survey_details.quality_of_classes_conducted")
        avg_ease = Survey.joins(:survey_detail).where(teacher_id: teacher.id).average("survey_details.ease_of_communication")
        avg_fair = Survey.joins(:survey_detail).where(teacher_id: teacher.id).average("survey_details.fair_and_clear_conditions")

        averages = {
          quality_of_classes_conducted: avg_quality && avg_quality.to_f.round(2),
          ease_of_communication: avg_ease && avg_ease.to_f.round(2),
          fair_and_clear_conditions: avg_fair && avg_fair.to_f.round(2)
        }

        render json: { surveys: result, averages: averages, count: surveys.size }
      end
    end
  end
end
