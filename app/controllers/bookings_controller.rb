class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :accept, :reject]
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
    if can? :accept, @booking
      @booking.accept
      redirect_to party_reports_path, notice: 'Festanmälan accepterad'
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera festanmälningar'
    end
  end

  # GET /bookings/1/reject
  def reject
    if can? :accept, @booking
      @booking.reject
      redirect_to party_reports_path, notice: 'Festanmälan avslagen'
    else
      redirect_to party_reports_path, alert: 'Du har inte privilegier till att hantera festanmälningar'
    end
  end


  private
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
