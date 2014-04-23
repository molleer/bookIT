class PartyReportsController < ApplicationController
  before_action :set_booking, except: :index
  authorize_resource

  def index
    @bookings = Booking.party_reported.in_future
  end

  def accept
    if can? :accept, @booking
      @booking.accept
      redirect_to party_reports_path, notice: 'Festanmälan accepterad'
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera festanmälningar'
    end
  end

  def reject
    if can? :accept, @booking
      @booking.reject
      # TODO: javascript prompt form -> send_reply
      redirect_to party_reports_path, notice: 'Festanmälan avslagen'
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera festanmälningar'
    end
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
