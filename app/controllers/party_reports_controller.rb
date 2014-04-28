class PartyReportsController < ApplicationController
  before_action :set_booking, except: :index

  def index
    @bookings = Booking.party_reported.in_future
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

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def mail_params
      params.permit(:email, :link, :id, :reason)
    end
end
