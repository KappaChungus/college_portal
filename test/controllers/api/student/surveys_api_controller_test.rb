require "test_helper"

class Api::SurveysApiControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users

  setup do
    @teacher = users(:teacher)
    @student = users(:student)

    @course1 = Course.create!(title: "Course One", code: "C101", teacher_id: @teacher.id)
    @course2 = Course.create!(title: "Course Two", code: "C102", teacher_id: @teacher.id)

    @sc1 = StudentCourse.create!(student_id: @student.id, teacher_id: @teacher.id, course_id: @course1.id, status: "current")
    @sc2 = StudentCourse.create!(student_id: @student.id, teacher_id: @teacher.id, course_id: @course2.id, status: "current")

    sign_in @student
  end

  test "current_teachers shows teachers with rated=false then create survey and rated becomes true" do
    get "/api/student/current_teachers"
    assert_response :success

    body = JSON.parse(response.body)
    assert body.is_a?(Array), "expected array of current teachers"
    entry = body.find { |e| e.dig("teacher", "id") == @teacher.id }
    assert entry, "expected teacher entry present"
    assert_equal false, entry["rated"], "teacher should initially be unrated"
    get "/api/student/teachers/#{@teacher.id}/rated"
    assert_response :success
    rated_body = JSON.parse(response.body)
    assert_equal false, rated_body["rated"]
    post "/api/student/surveys", params: {
      survey: {
        student_course_id: @sc1.id,
        quality_of_classes_conducted: 8,
        ease_of_communication: 7,
        fair_and_clear_conditions: 9,
        detailed_opinion: "Good course"
      }
    }, as: :json

    assert_response :created
    created = JSON.parse(response.body)
    assert created["success"], "expected success true"
    assert created["survey_id"].present?

    # attempt to rate the same student_course again -> should be rejected
    post "/api/student/surveys", params: {
      survey: {
        student_course_id: @sc1.id,
        quality_of_classes_conducted: 6,
        ease_of_communication: 6,
        fair_and_clear_conditions: 6,
        detailed_opinion: "Second attempt"
      }
    }, as: :json

    assert_response :unprocessable_entity
    repeat_err = JSON.parse(response.body)
    assert_equal "Teacher already rated for this course", repeat_err["error"]

    # now teacher_rated should be true
    get "/api/student/teachers/#{@teacher.id}/rated"
    assert_response :success
    rated_body2 = JSON.parse(response.body)
    assert_equal true, rated_body2["rated"], "teacher should be marked as rated after survey"
  end
end
