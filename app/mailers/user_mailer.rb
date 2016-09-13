class UserMailer < ActionMailer::Base
  default from: "bookit@chalmers.it"

  def reject_party(booking, mail_params)
    @booking = booking
    @params = mail_params
    mail to: @params[:email], subject: "Din bokning \"#{@booking.title}\" godkändes ej"
  end

  def reject_booking(booking, reason)
    @booking = booking
    @reason = reason
    mail to: booking.user.mail, subject: "Din bokning \"#{@booking.title}\" avslogs"
  end
end
