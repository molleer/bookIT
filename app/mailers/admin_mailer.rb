class AdminMailer < ActionMailer::Base
  include EmailRecipients

  default from: "bookit@chalmers.it"

  def booking_report(booking)
    @booking = booking
    @url = booking_url(@booking)

    recipients = [ORDF_PRIT_MAIL, @booking.user.mail]

    recipients << VO_MAIL if @booking.party_report.present?
    subject = "#{@booking.party_report.present? ? 'Aktivitetsanmälan' : 'Bokning'} av #{@booking.room}, #{@booking.booking_range}"

    mail to: recipients, subject: subject, reply_to: @booking.user.mail
  end

  def chalmers_report(bookings)
    @bookings = bookings
    # If you change this, make sure to edit app/views/party_reports/_send_bookings.html.erb

    subject = "Arrangemangsanmälan Hubben"

    mail to: CHALMERS_TO, subject: subject, from: VO_MAIL, bcc: CHALMERS_BCC
  end

  def chalmers_message(msg)
    subject = "Arrangemangsanmälan Hubben"
    mail to: CHALMERS_TO, subject: subject, from: VO_MAIL, bcc: CHALMERS_BCC do |format|
      format.text { render text: msg }
    end
  end

  def remind_vo(reports)
    @reports = reports
    subject = "Oskickad aktivitetsanmälan inom 48h"
    mail to: VO_MAIL, subject: subject
  end
end
