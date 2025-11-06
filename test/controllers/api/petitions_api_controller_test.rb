require "test_helper"

class Api::PetitionsApiControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @student = users(:student)
    sign_in @student
  end

  test "create petition and list my_petitions" do
    post "/api/student/petitions", params: {
      petition: {
        topic: "conditional promotion",
        petition_content: "I request conditional promotion due to..."
      }
    }, as: :json

    assert_response :created
    created = JSON.parse(response.body)
    assert created["id"].present?
    assert_equal "conditional promotion", created["topic"]

    # list petitions
    get "/api/student/petitions"
    assert_response :success
    list = JSON.parse(response.body)
    assert list.is_a?(Array)
    found = list.find { |p| p["id"] == created["id"] }
    assert found, "created petition should appear in my_petitions"
    assert_equal "conditional promotion", found["topic"]
    assert_equal "pending", found["status"]
  end

  test "create petition with invalid topic returns errors" do
    post "/api/student/petitions", params: {
      petition: {
        topic: "invalid topic",
        petition_content: "content"
      }
    }, as: :json

    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert body["errors"].is_a?(Array)
    assert body["errors"].any? { |e| e =~ /not included/ }, "expected inclusion error"
  end

  test "create petition without content returns errors" do
    post "/api/student/petitions", params: {
      petition: {
        topic: "resignation from studies",
        petition_content: ""
      }
    }, as: :json

    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert body["errors"].is_a?(Array)
    assert body["errors"].any? { |e| e =~ /can't be blank/ }, "expected can't be blank error"
  end
end
