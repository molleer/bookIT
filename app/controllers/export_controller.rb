class ExportController < ApplicationController
  def show
    @room = Room.find_by(name: params[:room_id].titlecase)
    send_data(RoomCalendar.new(@room),
                filename: "#{@room.name}.txt",
                disposition: :inline)
  end
end
