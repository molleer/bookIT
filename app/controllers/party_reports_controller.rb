class PartyReportsController < ApplicationController
  before_action :set_booking, except: [:index, :send_bookings, :preview_bookings, :send_reply]
  authorize_resource

  def index
    if cannot? :accept, PartyReport
      redirect_to bookings_path, notice: 'Du har inte tillåtelse att visa denna sidan!'
    end

    sorted = PartyReport.order(:begin_date)

    @not_accepted_reports = sorted.waiting
    @unsent_reports = sorted.accepted.unsent
    @sent_reports = PartyReport.accepted.sent.limit(10).order(sent_at: :desc).where(deleted_at: nil)

  end

  def reply
  end

  def send_reply
    @report = PartyReport.find_by booking_id: params[:id]
    if @report.present?
      begin
        @report.reject!
        UserMailer.reject_party(@report, mail_params).deliver_now
        redirect_to party_reports_path, notice: 'Aktivitetsanmälan avslagen, mail har skickats till anmälaren'
      rescue ActiveRecord::RecordInvalid => e
        redirect_to party_reports_path, alert: e.message
      end
    end
  end

  def preview_bookings
    bookings = Booking.where(id: params[:report_ids]).order(:begin_date)
    mail = AdminMailer.chalmers_report(bookings)
    render json: {
      to: mail.to,
      bcc: mail.bcc,
      source: mail.body.raw_source,
      report_ids: params[:report_ids]
    }
  end

  def send_bookings
    @report = PartyReport.find(params[:report_ids])
    # Thread.new do
      StudentPortalReporter.new.party_report(@report)
    # end
    # AdminMailer.chalmers_message(params[:message]).deliver_now

    PartyReport.where(id: params[:report_ids]).update_all(sent_at: Time.zone.now)
    redirect_to party_reports_path, notice: 'Aktivitetsanmälan har skickats till Chalmers!'
  end

  # GET /bookings/1/accept
  def accept
    if can? :accept, @report
      begin
        @report.accept!
        redirect_to party_reports_path, notice: 'Aktivitetsanmälan accepterad'
      rescue ActiveRecord::RecordInvalid => e
        redirect_to party_reports_path, alert: e.message
      end
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera aktivitetsanmälningar'
    end
  end

  # GET /bookings/1/reject
  def reject
    if can? :accept, @report
      begin
        @report.reject!
        redirect_to party_reports_path, notice: 'Aktivitetsanmälan avslagen'
      rescue ActiveRecord::RecordInvalid => e
        redirect_to party_reports_path, alert: e.message
      end
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera aktivitetsanmälningar'
    end
  end

  # GET /bookings/1/mark_as_sent
  def mark_as_sent
    if can? :accept, @report
      begin
        if params[:sent] == '1'
          @report.update(sent_at: Time.zone.now, accepted: true)
          redirect_to @report.booking, notice: 'Aktivitetsanmälan markerad som skickad.'
        else
          @report.update(sent_at: nil)
          redirect_to @report.booking, notice: 'Aktivitetsanmälan markerad som oskickad.'
        end

      rescue ActiveRecord::RecordInvalid => e
        redirect_to @report.booking, alert: e.message
      end
    else
      redirect_to @report.booking, alert: 'Du har inte privilegier till att hantera aktivitetsanmälningar'
    end
  end

  private
    def set_booking
      @report = PartyReport.find(params[:id])
    end

    def mail_params
      params.permit(:email, :link, :id, :reason)
    end
end
