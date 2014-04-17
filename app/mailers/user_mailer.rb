class UserMailer < ActionMailer::Base
  default from: "bookit@chalmers.it"

  def rejected_booking(booking)
    @booking = booking
    # mail to: @booking.user.mail, subject: "Din bokning #{@booking.booking_range} av #{@booking.room} godkändes ej"
  end
end
