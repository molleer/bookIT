class PartyReportsController < ApplicationController
  before_action :set_booking, except: [:index, :send_bookings, :preview_bookings]

  def index
    bookings = Booking.party_reported
    @not_accepted_bookings = bookings.waiting
    @unsent_bookings = bookings.accepted.sent(false)
    @sent_bookings = bookings.accepted.sent(true)
  end

  def reply
  end

  def send_reply
    if @booking.present?
      @booking.reject
      UserMailer.reject_party(@booking, mail_params).deliver
      redirect_to party_reports_path, notice: 'Festanmälan avslagen, mail har skickats till anmälaren'
    end
  end

  def preview_bookings
    bookings = Booking.find(params[:booking_ids])
    mail = AdminMailer.chalmers_report(bookings)
    render text: mail.body.raw_source
  end

  def send_bookings
    AdminMailer.chalmers_message(params[:message]).deliver
    
    redirect_to party_reports_path, notice: 'Festanmälan har skickats till Chalmers!'
  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def mail_params
      params.permit(:email, :link, :id, :reason)
    end
end
