require "test_helper"

class Api::Teacher::ManageCoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @teacher = users(:teacher)
    @student = users(:student)
    @course = courses(:math_course)

    # ensure a StudentCourse exists
    @student_course = StudentCourse.find_or_create_by!(student: @student, teacher: @teacher, course: @course, status: "current")
  end

  test "teacher can post a mark and then retrieve it via marks endpoint" do
    sign_in @teacher

    # initially no marks
    get "/api/teacher/courses/#{@course.id}/student/#{@student.id}/marks", as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal [], body["marks"]

    # post a new mark
    post "/api/teacher/courses/#{@course.id}/student/#{@student.id}/mark", params: { name: "Midterm", mark: 95 }, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_includes body.keys.map(&:to_s), "grades"
    grades = body["grades"]
    assert grades.is_a?(Array)
    assert_equal 1, grades.length
    assert_equal "Midterm", grades.first["name"]
    assert_equal 95, grades.first["mark"]

    # ensure marks endpoint now returns the new mark
    get "/api/teacher/courses/#{@course.id}/student/#{@student.id}/marks", as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body["marks"].length
    assert_equal "Midterm", body["marks"].first["name"]
    assert_equal 95, body["marks"].first["mark"]
  end

  test "student cannot post a mark" do
    sign_in @student

    post "/api/teacher/courses/#{@course.id}/student/#{@student.id}/mark", params: { name: "Unauthorized", mark: 50 }, as: :json
    assert_response :forbidden
  end

  test "teacher cannot post mark for a course they don't teach" do
  # create another teacher and course not taught by @teacher
  other_teacher = User.create!(name: "Other", email: "other_teacher@example.com", password: "password", type: "Teacher")
    other_course = Course.create!(title: "Other Course", code: "OTR101", teacher: other_teacher)

    sign_in @teacher

    post "/api/teacher/courses/#{other_course.id}/student/#{@student.id}/mark", params: { name: "UnauthorizedMark", mark: 10 }, as: :json
    assert_response :forbidden
  end
end
