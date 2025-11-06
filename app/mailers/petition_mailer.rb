class PetitionMailer < ApplicationMailer
  # Sends notification about a newly created petition.
  # Recipient defaults to credentials/admin env fallback.
  def new_petition(petition)
    @petition = petition
    @student = petition.student

    # prefer a dedicated dean/helpdesk address, fall back to admin_email or ENV
    recipient = Rails.application.credentials.dig(:dean_helpdesk_email) || Rails.application.credentials.dig(:admin_email) || ENV["DEAN_HELPDESK_EMAIL"] || ENV["ADMIN_EMAIL"] || "admin@example.com"

    mail(
      to: recipient,
      from: @student.email,
      subject: @petition.topic
    )
  end
end
