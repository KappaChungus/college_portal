require "test_helper"

class TeacherDashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @teacher = users(:teacher)
    sign_in @teacher
  end

  test "should get teacher dashboard" do
    # use the correct path helper from routes.rb
    get teacher_root_path
    assert_response :success
  end
end
