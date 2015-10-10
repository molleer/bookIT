json.array!(@bookings) do |booking|
  json.title booking.title
  json.start booking.begin_date
  json.end booking.end_date
  json.color booking.room.color if booking.room
  json.url booking_path(booking)
end
