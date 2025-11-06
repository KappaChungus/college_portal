require "test_helper"

class Api::Teacher::SurveysControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @teacher = users(:teacher)
    @student = users(:student)
    @course = courses(:math_course)

    # create a student_course linking student and course
    @student_course = StudentCourse.create!(student: @student, teacher: @teacher, course: @course, status: "current")

    # create a survey with details
    @survey = Survey.create!(teacher: @teacher, student_course: @student_course)
    @survey.create_survey_detail!(quality_of_classes_conducted: 8, ease_of_communication: 9, fair_and_clear_conditions: 7, detailed_opinion: "Good")
  end

  test "teacher can fetch surveys with averages" do
    sign_in @teacher
    get "/api/teacher/surveys", as: :json

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 1, body["count"]
    assert_in_delta 8.0, body["averages"]["quality_of_classes_conducted"].to_f, 0.01
    assert_in_delta 9.0, body["averages"]["ease_of_communication"].to_f, 0.01
    assert_in_delta 7.0, body["averages"]["fair_and_clear_conditions"].to_f, 0.01

    surveys = body["surveys"]
    assert surveys.is_a?(Array)
    assert_equal @survey.id, surveys.first["id"]
  end

  test "student cannot access teacher surveys" do
    sign_in @student
    get "/api/teacher/surveys", as: :json
    assert_response :forbidden
  end
end
