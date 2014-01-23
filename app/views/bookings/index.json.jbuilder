json.array!(@bookings) do |booking|
  json.extract! booking, :id, :cid, :start, :end, :group, :description, :festansvarig, :festnumber, :room_id
  json.url booking_url(booking, format: :json)
end
