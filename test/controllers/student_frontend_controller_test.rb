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

  test "student should NOT access teacher dashboard" do
    get teacher_frontend_index_path
    assert_redirected_to unauthenticated_root_path
  end
end
