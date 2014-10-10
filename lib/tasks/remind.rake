namespace :bookit do
	desc "Send reminder by email"
	task remind: :environment do
		@bookings = Booking.party_reported.in_future.unsent.within(48.hours.from_now)
		@bookings
		AdminMailer.remind_vo(@bookings).deliver if @bookings.any?
	end
end
