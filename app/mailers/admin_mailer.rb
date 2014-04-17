class AdminMailer < ActionMailer::Base
  default from: "bookit@chalmers.it"

  VO_MAIL = 'vo@chalmers.it'
  PRIT_MAIL = 'prit@chalmers.it'

  def party_report(booking)
    @booking = booking
    # mail to: VO_MAIL, subject: "Festanmälan #{@booking.booking_range}"
  end

  def booking_report(booking)
    @booking = booking
    # mail to: PRIT_MAIL, subject: "Bokning av #{@booking.room} #{@booking.booking_range}"
  end
end
