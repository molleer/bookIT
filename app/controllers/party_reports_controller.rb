class PartyReportsController < ApplicationController
  before_action :set_booking, except: :index

  def index
    @bookings = Booking.party_reported.in_future
  end

  def reply
  end

  def send_reply

  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end
end
