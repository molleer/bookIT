class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
 # before_action :restrict_access, only: [:current]
  authorize_resource :except => [:current, :today]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.in_future.order(:begin_date)
    if params[:filter]
      filter = params[:filter].split ' '
      @bookings = @bookings.by_group_or_user(filter)
    end
  end

  def calendar_data
    @bookings = Booking.all

    if params[:start] && params[:end]
      @bookings = Booking.between(params[:start], Date.parse(params[:end]) + 1.day)
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  def current
    now = DateTime.now
    hubben = Room.find_by(name: 'Hubben')
    @current = Booking.in_room(hubben).where('begin_date <= ? and end_date >= ?', now, now).first
    unless @current.present?
      render json: {error: 'No current booking'}
    end
  end

  def today
    now = DateTime.now

    @bookings = Booking.where('end_date >= ? and begin_date <= ?', now - 2.hours, now + 24.hours)
    render :index
  end

  # GET /bookings/new
  def new
    date = DateTime.now.change(min: 0)
    @booking = Booking.new(user_id: current_user.cid, room: Room.find_by(name: 'Hubben'), begin_date: date, end_date: date + 2.hours)
    @booking.build_party_report
  end

  # GET /bookings/1/edit
  def edit
    @editing = true
    redirect_to :back, alert: 'Bokning är redan ivägskickad, får ej längre ändras' and return if party_report_sent?
    @booking.build_party_report unless @booking.party_report.present?
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
    redirect_to :back, alert: 'Bokning är redan ivägskickad, fär ej längre ändras' and return if party_report_sent?
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
    UserMailer.reject_booking(@booking, params[:reason]).deliver_now unless current_user == @booking.user
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :no_content }
    end
  end

  private
    def create_single_booking
      @booking = Booking.new({user_id: current_user.cid}.merge(booking_params))
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
      @booking = Booking.new({user_id: current_user.cid}.merge(booking_params))
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
      party_report_attributes = []
      if params[:party]
        party_report_attributes = [:party_responsible_name, :party_responsible_phone, :party_responsible_mail,
          :co_party_responsible_name, :co_party_responsible_phone, :co_party_responsible_mail, :liquor_license, :id]

        party_report_attributes << [:begin_date, :end_date] if params[:custom_party_date]
      end

      params.require(:booking).permit(:title, :group, :begin_date, :end_date, :description, :phone, :room_id, party_report_attributes: party_report_attributes)
    end

    def email_update
      # Send mail to P.R.I.T. (and maybe vo)
      AdminMailer.booking_report(@booking).deliver_now
    end

    def party_report_sent?
      @booking.party_report && @booking.party_report.sent?
    end

    def restrict_access
      authenticate_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end
end
