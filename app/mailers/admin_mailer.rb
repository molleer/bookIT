class AdminMailer < ActionMailer::Base
  default from: "bookit@chalmers.it"

  VO_MAIL = 'vo@chalmers.it'
  PRIT_MAIL = 'prit@chalmers.it'

  def booking_report(booking)
    @booking = booking
    @url = booking_url(@booking, host: 'localhost:3000') # TODO: move to production.rb

    recipients = [PRIT_MAIL, @booking.user.mail]

    recipients << VO_MAIL if @booking.party
    subject = "#{@booking.party ? 'Festanmälan' : 'Bokning'} av #{@booking.room}, #{@booking.booking_range}"

    mail to: recipients, subject: subject, reply_to: @booking.user.mail
  end
end