class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, 
                                      :accept, :reject, :mark_as_sent]
  authorize_resource

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.in_future.order(:begin_date)
    if params[:filter]
      filter = params[:filter].split ' '
      @bookings = @bookings.by_group_or_user(filter)
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = current_user.bookings.build(room: Room.find_by(name: 'Hubben'))
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    unless params[:repeat_booking]
      create_single_booking
    else
      create_repeated_booking
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)

        email_update # tell about the updated booking

        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    UserMailer.reject_booking(@booking, params[:reason]).deliver unless current_user == @booking.user
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :no_content }
    end
  end

  # GET /bookings/1/accept
  def accept
    if can?(:accept, @booking)
      begin
        @booking.accept
        redirect_to party_reports_path, notice: 'Festanmälan accepterad'
      rescue ActiveRecord::RecordInvalid => e
        redirect_to party_reports_path, alert: e.message
      end
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera festanmälningar'
    end
  end

  # GET /bookings/1/reject
  def reject
    if can?(:accept, @booking)
      begin
        @booking.reject
        redirect_to party_reports_path, notice: 'Festanmälan avslagen'
      rescue ActiveRecord::RecordInvalid => e
        redirect_to party_reports_path, alert: e.message
      end
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera festanmälningar'
    end
  end

  # GET /bookings/1/mark_as_sent
  def mark_as_sent
    if can?(:accept, @booking)
      begin
        if params[:sent]=='1' 
          @booking.update(sent: true, accepted: true)
          redirect_to @booking, notice: 'Booking was marked as sent.'
        else
          @booking.update(sent: false)
          redirect_to @booking, notice: 'Booking was marked as unsent.'
        end
        
      rescue ActiveRecord::RecordInvalid => e
        redirect_to @booking, alert: e.message
      end
    else
      redirect_to @booking, alert: 'Du har inte privilegier till att hantera festanmälningar'
    end
  end

  private
    def create_single_booking
      @booking = current_user.bookings.build(booking_params)
      respond_to do |format|
        if @booking.save

          email_update # tell about the new booking

          format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
          format.json { render action: 'show', status: :created, location: @booking }
        else
          format.html { render action: 'new' }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end

    def create_repeated_booking
      @booking = current_user.bookings.build(booking_params)
      @failed_bookings = []
      nbr_succeeded = 0
      end_date = params[:repeat_until].to_date
      final_end_date = [end_date, Date.today + 6.months].min

      while final_end_date >= @booking.begin_date
        unless @booking.save
          @failed_bookings << @booking
        else
          email_update # tell about the new booking
          nbr_succeeded += 1
        end

        @booking = @booking.dup
        @booking.begin_date += 1.week
        @booking.end_date += 1.week
      end

      if @failed_bookings.any?
        @booking = @failed_bookings.first
        render action: 'new'
      else
        redirect_to @booking, notice: "#{nbr_succeeded} bookings was successfully created."  
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:title, :group, :begin_date, :end_date, :description, :party, :party_responsible, :liquor_license, :party_responsible_phone, :phone, :room_id, :title)
    end

    def email_update
      # Send mail to P.R.I.T. (and maybe vo)
      AdminMailer.booking_report(@booking).deliver
    end
end
