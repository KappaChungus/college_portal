require "test_helper"

class Api::Teacher::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teacher = users(:teacher_one)
    @student = users(:student_one)
    sign_in @teacher
  end

  test "teacher can get all announcements" do
    get api_teacher_announcements_path
    assert_response :success

    json_response = JSON.parse(response.body)
    assert json_response.is_a?(Array)
  end

  test "teacher can create announcement" do
    assert_difference("Announcement.count", 1) do
      post api_teacher_announcements_path, params: {
        announcement: {
          title: "Test Announcement",
          content: "This is a test announcement content",
          date: Date.today
        }
      }
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal "Test Announcement", json_response["title"]
    assert_equal "This is a test announcement content", json_response["content"]
  end

  test "teacher cannot create announcement without title" do
    assert_no_difference("Announcement.count") do
      post api_teacher_announcements_path, params: {
        announcement: {
          content: "This is a test announcement content",
          date: Date.today
        }
      }
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
  end

  test "teacher can update their own announcement" do
    announcement = Announcement.create!(
      teacher: @teacher,
      title: "Original Title",
      content: "Original Content",
      date: Date.today
    )

    put "/api/teacher/announcements/#{announcement.id}", params: {
      announcement: {
        title: "Updated Title",
        content: "Updated Content"
      }
    }

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "Updated Title", json_response["title"]
    assert_equal "Updated Content", json_response["content"]
  end

  test "teacher can delete their own announcement" do
    announcement = Announcement.create!(
      teacher: @teacher,
      title: "To Delete",
      content: "This will be deleted",
      date: Date.today
    )

    assert_difference("Announcement.count", -1) do
      delete "/api/teacher/announcements/#{announcement.id}"
    end

    assert_response :no_content
  end

  test "student cannot create announcement" do
    sign_out @teacher
    sign_in @student

    post api_teacher_announcements_path, params: {
      announcement: {
        title: "Test",
        content: "Test",
        date: Date.today
      }
    }

    # Should get unauthorized or redirect
    assert_not_equal :created, response.status
  end
end
