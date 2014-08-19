class AdminMailer < ActionMailer::Base
  default from: "bookit@chalmers.it"

  VO_MAIL = 'vo@chalmers.it'
  PRIT_MAIL = 'prit@chalmers.it'
  CHALMERS_MAIL = ['vso@chalmers.se', 'chalmersvakten.aos@chalmers.se', 'kent.wikersten@chalmers.se']

  def booking_report(booking)
    @booking = booking
    @url = booking_url(@booking)

    recipients = [PRIT_MAIL, @booking.user.mail]

    recipients << VO_MAIL if @booking.party
    subject = "#{@booking.party ? 'Festanmälan' : 'Bokning'} av #{@booking.room}, #{@booking.booking_range}"

    mail to: recipients, subject: subject, reply_to: @booking.user.mail
  end

  def chalmers_report(bookings)
    @bookings = bookings
    # If you change this, make sure to edit app/views/party_reports/_send_bookings.html.erb
    # recipients = CHALMERS_MAIL << VO_MAIL
    recipients = VO_MAIL

    subject = "Festanmälan Hubben"

    mail to: recipients, subject: subject, from: VO_MAIL
  end

  def chalmers_message(msg)
    # recipients = CHALMERS_MAIL << VO_MAIL
    recipients = VO_MAIL
    subject = "Festanmälan Hubben"
    mail to: recipients, subject: subject, from: VO_MAIL do |format|
      format.text { render text: msg }
    end
  end
end
