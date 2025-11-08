require "test_helper"

class StudentFrontendControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @student = users(:student)
    sign_in @student
  end

  test "should get student dashboard" do
    # use the correct path helper from routes.rb
    get student_root_path
    assert_response :success
  end

  test "student should NOT access teacher-specific page" do
    # Students accessing teacher-only routes get 404 (route doesn't exist for them)
    # This is due to the authenticated constraint in routes.rb
    get manage_courses_path
    assert_response :not_found
  end
end
