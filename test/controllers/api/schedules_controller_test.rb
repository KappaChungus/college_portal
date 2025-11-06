require "test_helper"

class Api::SchedulesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @teacher = users(:teacher)
    @student = users(:student)
    @course = courses(:math_course)

    # create a group for the schedule
    @group = Group.create!(name: "Test Group")

    # create a schedule session for the teacher
    @session = Schedule.create!(
      group: @group,
      course: @course,
      teacher: @teacher,
      day_of_week: 1,
      start_time: "09:00",
      end_time: "10:00",
      room: "101"
    )
  end

  test "teacher can fetch their schedule grouped by day" do
    sign_in @teacher
    get "/api/teacher/schedule", as: :json

    assert_response :success
    body = JSON.parse(response.body)

    # keys are day_of_week as strings
    assert body.key?("1"), "expected day_of_week 1 to be present"
    day_sessions = body["1"]
    assert day_sessions.is_a?(Array)

    s = day_sessions.find { |d| d["id"] == @session.id }
    assert s, "expected created session to be present"
    assert_equal "101", s["room"]
    assert_equal @course.code, s["course"]["code"]
    assert_equal @group.name, s["group"]["name"]
  end

  test "student cannot access teacher schedule" do
    sign_in @student
    get "/api/teacher/schedule", as: :json
    assert_response :forbidden
  end
end
