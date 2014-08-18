json.array!(@bookings) do |booking|
  json.extract! booking, :id,
      :user_id, :begin_date, :end_date, :group, :description, :title
  json.set! :room, booking.room.name
end
