require "test_helper"

class PetitionMailerTest < ActionMailer::TestCase
  test "new_petition uses recipient from ENV and includes content" do
    student = users(:student)

    # create a petition record (topic must be a valid inclusion)
    petition = Petition.create!(student: student, topic: "conditional promotion", petition_content: "Please consider my case.")

    # ensure ENV is set for the duration of the test
    original = ENV["DEAN_HELPDESK_EMAIL"]
    ENV["DEAN_HELPDESK_EMAIL"] = "dean@example.test"

    email = PetitionMailer.new_petition(petition)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "dean@example.test" ], email.to
    assert_equal [ student.email ], email.from
    assert_equal petition.topic, email.subject
    assert_includes email.body.encoded, petition.petition_content

  ensure
    # cleanup
    if original.nil?
      ENV.delete("DEAN_HELPDESK_EMAIL")
    else
      ENV["DEAN_HELPDESK_EMAIL"] = original
    end
  end
end
