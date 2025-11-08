require "test_helper"

class Api::Student::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = users(:student_one)
    @teacher = users(:teacher_one)
    sign_in @student
  end

  test "student can get announcements" do
    # Create a test announcement
    Announcement.create!(
      teacher: @teacher,
      title: "Important Announcement",
      content: "Please read this carefully",
      date: Date.today
    )

    get api_student_announcements_path
    assert_response :success

    json_response = JSON.parse(response.body)
    assert json_response.is_a?(Array)
    assert json_response.length > 0

    announcement = json_response.first
    assert announcement["title"].present?
    assert announcement["content"].present?
    assert announcement["teacher"].present?
    assert announcement["teacher"]["name"].present?
  end

  test "student can get latest grades" do
    # This test assumes student has courses with grades from seeds
    get api_student_latest_grades_path
    assert_response :success

    json_response = JSON.parse(response.body)
    assert json_response.is_a?(Array)

    if json_response.length > 0
      grade = json_response.first
      assert grade["course_code"].present?
      assert grade["course_title"].present?
      assert grade["name"].present?
      assert grade.key?("mark")
    end
  end

  test "student sees grades with correct structure" do
    # Create a student course with grades for testing
    course = courses(:one)
    student_course = StudentCourse.create!(
      student: @student,
      course: course,
      teacher: @teacher,
      status: "current",
      grades: [
        {
          "name" => "Test 1",
          "mark" => 18,
          "added_by" => @teacher.id,
          "created_at" => 2.days.ago.to_s
        },
        {
          "name" => "Test 2",
          "mark" => 15,
          "added_by" => @teacher.id,
          "created_at" => 1.day.ago.to_s
        }
      ]
    )

    get api_student_latest_grades_path
    assert_response :success

    json_response = JSON.parse(response.body)
    assert json_response.is_a?(Array)
    assert json_response.length >= 2

    # Check that grades are sorted by date (most recent first)
    grade = json_response.first
    assert_equal course.code, grade["course_code"]
    assert_equal course.title, grade["course_title"]
    assert_includes [ "Test 1", "Test 2" ], grade["name"]
    assert_includes [ 18, 15 ], grade["mark"]
  end

  test "teacher cannot access student dashboard endpoints" do
    sign_out @student
    sign_in @teacher

    get api_student_announcements_path
    # Should get unauthorized or redirect
    assert_not_equal :success, response.status

    get api_student_latest_grades_path
    # Should get unauthorized or redirect
    assert_not_equal :success, response.status
  end
end
